use InversionList;

plan(15);

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
    say('# IL after second add_range', nqp::join(', ', $il._il));
    ok(!$il.contains(7), 'extended does not contain 7');
    ok( $il.contains(8), 'extended contains 8');
    ok( $il.contains(9), 'extended contains 9');
    ok( $il.contains(10), 'extended contains 10');
    ok(!$il.contains(21), 'extended does not contain 21');
}
