use InversionList;

plan(4);

{
    my $il := InversionList.new();
    $il.add_range(10, 20);
    ok($il._find_pos(1)  == 0, "1 is not in the IL");
    ok($il._find_pos(10) == 1, "10 is in the IL");
    ok($il._find_pos(20) == 1, "20 is in the IL");
    ok($il._find_pos(30) == 2, "30 is not in the IL");
}
