use InversionList;

plan(25);

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
