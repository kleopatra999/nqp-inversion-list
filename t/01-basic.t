use InversionList;

plan(33);

{
    my $il := InversionList.new();
    $il.add_range(10, 20);
    ok($il._find_pos(1)  == 0, "_find_pos(1)");
    ok($il._find_pos(10) == 0, "_find_pos(10)");
    ok($il._find_pos(20) == 1, "_find_pos(20)");
    ok($il._find_pos(30) == 2, "_find_pos(30)");
    ok(!$il.contains(0), 'does not contain 0');
    ok(!$il.contains(9), 'does not contain 9');
    ok( $il.contains(10), 'contains 10');
    ok( $il.contains(15), 'contains 15');
    ok( $il.contains(20), 'contains 20');
    ok(!$il.contains(21), 'does not contain 21');

    $il.add_range(8, 10);
    say('# IL after second add_range ', nqp::join(', ', $il._il));
    ok(!$il.contains(7), 'extended does not contain 7');
    ok( $il.contains(8), 'extended contains 8');
    ok( $il.contains(9), 'extended contains 9');
    ok( $il.contains(10), 'extended contains 10');
    ok(!$il.contains(21), 'extended does not contain 21');
}

{
    my $il := InversionList.new();
    $il.add_range(10, 20);
    $il := $il.invert;
    say('# IL after inversion ', nqp::join(', ', $il._il));
    ok( $il.contains(0), 'contains 0');
    ok( $il.contains(9), 'contains 9');
    ok(!$il.contains(10), 'does not contain 10');
    ok(!$il.contains(15), 'does not contain 15');
    ok(!$il.contains(20), 'does not contain 20');
    ok( $il.contains(21), 'contains 21');
}

{
    my $il := InversionList.new();
    $il.add_range(5, 10);
    $il.add_range(15, 20);
    my @cp1 := $il.copy._il;

    say('# IL before double inversion ', nqp::join(', ', $il._il));
    $il := $il.invert;
    $il := $il.invert;
    say('# IL after double inversion  ', nqp::join(', ', $il._il));

    ok(nqp::elems($il._il) == nqp::elems(@cp1), "inverting twice keeps number of elements");
    my $succ := 1;
    for $il._il {
        $succ := $succ && ($_ == nqp::shift(@cp1));
    }
    ok($succ, "elements are the same as before");
}

{
    my $il := InversionList.new();
    $il.add_range(5, 10);
    $il.add_range(15, 20);
    my @cp1 := $il.copy._il;
    my $la := InversionList.new();
    my $lb := InversionList.new();
    $la.add_range(5, 10);
    $lb.add_range(15, 20);
    my $union := $la.union($lb);
    my $union2 := $lb.union($la);
    
    ok(nqp::elems($union._il) == nqp::elems(@cp1), "union and separate merging of ranges has same amount of elems");
    
    say('# original        ', nqp::join(', ', $il._il));
    say('# forwards union  ', nqp::join(', ', $union._il));
    say('# backwards union ', nqp::join(', ', $union2._il));

    my $succ := 1;
    my $same := 1;
    my @union2 := $union2.copy._il;
    for $union._il() {
        $succ := $succ && ($_ == nqp::shift(@cp1));
        $same := $same && ($_ == nqp::shift(@union2));
    }
    ok($succ, "elements are the same as before");
    ok($same, "elements are the same between unions");

    ok(nqp::elems($union2._il) == nqp::elems($union._il), "order of union operation doesn't matter for amount of elems");
}

{
    my $left := InversionList.new();
    $left.add_range(5, 15);
    my $right := InversionList.new();
    $right.add_range(10, 20);
    my $il := $left.intersection($right);
    say('# left after intersection         ', nqp::join(', ', $left._il));
    say('# intersection after intersection ', nqp::join(', ', $il._il));
    say('# right after intersection        ', nqp::join(', ', $right._il));
    ok(!$il.contains(5),  "intersection doesn't contain 5");
    ok( $il.contains(10), "intersection contains 10");
    ok( $il.contains(15), "intersection contains 15");
    ok(!$il.contains(20), "intersection doesn't contain 20");
}

{
    my $la := InversionList.new();
    $la.add_range(10, 15);
    $la.add_range(15, 20);
    my @cpa := $la._il();

    my $lb := InversionList.new();
    $lb.add_range(10, 20);
    my @cpb := $lb._il();

    say('# one range  ', nqp::join(', ', @cpa));
    say('# two ranges ', nqp::join(', ', @cpb));
    ok(nqp::elems(@cpa) == nqp::elems(@cpb), "10-15 & 15-20 gives same number of elements as 10-20");

    my $succ := 1;
    for @cpa {
        $succ := $succ && ($_ == nqp::shift(@cpb));
    }
    ok($succ, "10-15 & 15-20 gives same elements as 10-20");
}
