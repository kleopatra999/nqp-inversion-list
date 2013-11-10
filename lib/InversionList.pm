# Unicode codepoints only go to 0x10FFFF, so anyhting larger
# than that is basically infinity.
my int $inf := 0x110000;

class InversionList {
    has @!codepoints;

    # blatantly stolen from the p5 module Set::IntSpan::Fast::P
    # it's distributed under the same terms as Perl itself,
    # and since our Perl is Perl 6, it is comptabile with Perl 6.
    #
    # Return the index of the first element >= the supplied value. If the
    # supplied value is larger than any element in the list the returned
    # value will be equal to the size of the list.
    method _find_pos(int $val, int $low?) {
        my int $high := nqp::elems(@!codepoints);
        while $low < $high {
            my int $mid := nqp::div_i($low + $high, 2);
            if $val < @!codepoints[$mid] {
                $high := $mid;
            }
            elsif $val > @!codepoints[$mid] {
                $low := $mid + 1;
            }
            else {
                return $mid;
            }
        }
        return $low;
    }

    method _il() { @!codepoints }

    method invert() {
        if @!codepoints {
            if @!codepoints[0] == 0 {
                nqp::shift(@!codepoints);
            }
            else {
                nqp::unshift(@!codepoints, 0);
            }

            if @!codepoints[-1] == $inf {
                nqp::pop(@!codepoints);
            }
            else {
                nqp::push(@!codepoints, $inf);
            }
        }
        else {
            @!codepoints := [0, $inf];
        }
        self;
    }

    method copy() {
        my @codes_copy := nqp::list();
        for @!codepoints {
            @codes_copy.push($_);
        }
        InversionList.new(:codepoints(@codes_copy));
    }

    method add_range(int $from, int $to) {
        $to := $to + 1;
        my int $fpos := self._find_pos($from);
        my int $tpos := self._find_pos($to + 1, $fpos);
        $from := @!codepoints[ --$fpos ] if $fpos +& 1;
        $to   := @!codepoints[ $tpos++ ] if $tpos +& 1;
        nqp::splice(@!codepoints, [$from, $to], $fpos, $tpos - $fpos);
    }

    method merge(InversionList $other) {
        my @other := $other._il;
        my int $elems := nqp::elems(@other);
        my int $i := 0;
        while $i < $elems {
            self.add_range(@other[$i], @other[$i + 1] - 1);
            $i := $i + 2;
        }
        self;
    }

    method union(InversionList $other) {
        self.copy.merge($other);
    }

    method complement() {
        self.copy.invert();
    }

    method intersection(InversionList $other) {
        self.complement.merge($other.complement).invert;
    }

    method new(:@codepoints?) {
        my $new := self.CREATE();
        nqp::bindattr($new, InversionList, '@!codepoints',
            nqp::isnull(@codepoints) ?? nqp::list() !! @codepoints);
        $new;
    }
    method contains(int $codepoint) {
        1 +& self._find_pos($codepoint + 1);
    }
}
