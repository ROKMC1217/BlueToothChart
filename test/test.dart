void main() {
  final list1 = <int>[1, 2, 3, 4];
  final list2 = <int>[5, 6, 7, 8, 9];
  // Copies the 4th and 5th items in list2 as the 2nd and 3rd items
  // of list1.
  const skipCount = 3;
  list1.setRange(1, 3, list2, skipCount);
  print(list1); // [1, 8, 9, 4]
}
