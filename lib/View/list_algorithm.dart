import 'package:flutter/material.dart';
import 'dart:math' as m;

class ListAlgorithm extends StatefulWidget {
  const ListAlgorithm({super.key});

  @override
  State<ListAlgorithm> createState() => _ListAlgorithmState();
}

class _ListAlgorithmState extends State<ListAlgorithm> {
  List<int> s = List.generate((110), (index) {
    return (m.Random().nextDouble() * (300 - 17) + 1).ceil();
  });
  bool run = false;
  List<bool> runs = List.filled(7, false);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // if (kDebugMode) print(s);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'List Algorithm',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: () {
              s = List.generate(110, (index) {
                return (m.Random().nextDouble() * (300) + 1).ceil();
              });
              setState(() {});
            },
            icon: const Icon(
              Icons.replay,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              width: size.width - 16.0,
              height: 300.0,
              child: Container(
                color: Colors.black12,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (int i = 0; i < s.length; i++)
                      Container(
                        width: (size.width - 16.0) / 110,
                        height: s[i].toDouble(),
                        color: Colors.blue,
                      )
                  ],
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10.0)),
            SizedBox(
              height: 50.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SortAlgorithm(
                      run: runs[0],
                      title: 'Merge Sort',
                      onTap: () async {
                        setState(() {
                          run = true;
                          runs[0] = true;
                        });

                        Future<void> merge(int left, int mid, int right) async {
                          int leftSize = mid - left + 1;
                          int rightSize = right - mid;
                          List<int> leftArr = s.sublist(left, mid + 1);
                          List<int> rightArr = s.sublist(mid + 1, right + 1);
                          int i = 0, j = 0, k = left;
                          while (i < leftSize && j < rightSize && run) {
                            await Future.delayed(const Duration(microseconds: 1000)); // Delay for visualization
                            if (leftArr[i] <= rightArr[j]) {
                              s[k] = leftArr[i];
                              i++;
                            } else {
                              s[k] = rightArr[j];
                              j++;
                            }
                            setState(() {}); // Update the UI
                            k++;
                          }
                          // Copy any remaining elements from left and right arrays
                          while (i < leftSize && run) {
                            s[k] = leftArr[i];
                            i++;
                            k++;
                            setState(() {}); // Update the UI
                          }
                          while (j < rightSize && run) {
                            s[k] = rightArr[j];
                            j++;
                            k++;
                            setState(() {}); // Update the UI
                          }
                        }

                        Future<void> mergeSort(int left, int right) async {
                          if (left >= right) return;
                          int mid = (left + right) ~/ 2;
                          await mergeSort(left, mid);
                          await mergeSort(mid + 1, right);
                          await merge(left, mid, right); // Merge with a slight delay for visualization
                        }

                        await mergeSort(0, s.length - 1);
                        setState(() {
                          run = false;
                          runs[0] = false;
                        });
                      }),
                  SortAlgorithm(
                    run: runs[1],
                    title: 'Bubble Sort',
                    onTap: () async {
                      setState(() {
                        run = true;
                        runs[1] = true;
                      });
                      int n = s.length;
                      bool swapped;
                      // Loop through all elements
                      for (int i = 0; i < n - 1 && run; i++) {
                        swapped = false;
                        // Loop through the list up to the last sorted position
                        for (int j = 0; j < n - i - 1 && run; j++) {
                          // Swap if the current element is greater than the next element
                          setState(() {
                            if (s[j] > s[j + 1]) {
                              int temp = s[j];
                              s[j] = s[j + 1];
                              s[j + 1] = temp;
                              swapped = true;
                            }
                          });
                          await Future.delayed(const Duration(microseconds: 200));
                          // sleep(const Duration(milliseconds: 200));
                        }
                        // If no elements were swapped2 in this iteration, the list is sorted
                        if (!swapped) {
                          break;
                        }
                      }
                      setState(() {
                        run = false;
                        runs[1] = false;
                      });
                    },
                  ),
                  SortAlgorithm(
                    run: runs[2],
                    title: 'Insertion Sort',
                    onTap: () async {
                      setState(() {
                        run = true;
                        runs[2] = true;
                      });
                      int n = s.length;
                      for (int i = 1; i < n && run; i++) {
                        int key = s[i];
                        int j = i - 1;
                        while (j >= 0 && s[j] > key && run) {
                          s[j + 1] = s[j];
                          j--;
                          setState(() {});
                          await Future.delayed(const Duration(microseconds: 900));
                        }
                        s[j + 1] = key;
                      }
                      setState(() {
                        run = false;
                        runs[2] = false;
                      });
                    },
                  ),
                  SortAlgorithm(
                    run: runs[3],
                    title: 'Selection Sort',
                    onTap: () async {
                      setState(() {
                        run = true;
                        runs[3] = true;
                      });
                      int n = s.length;
                      for (int i = 0; i < n - 1 && run; i++) {
                        int minIndex = i;
                        for (int j = i + 1; j < n && run; j++) {
                          if (s[j] < s[minIndex]) {
                            minIndex = j;
                          }
                        }
                        int temp = s[minIndex];
                        s[minIndex] = s[i];
                        s[i] = temp;
                        setState(() {});
                        await Future.delayed(const Duration(microseconds: 10000));
                      }
                      setState(() {
                        run = false;
                        runs[3] = false;
                      });
                    },
                  ),
                  SortAlgorithm(
                    run: runs[4],
                    title: 'Quick Sort',
                    onTap: () async {
                      setState(() {
                        run = true;
                        runs[4] = true;
                      });
                      void _swap(int i, int j) {
                        int temp = s[i];
                        s[i] = s[j];
                        s[j] = temp;
                      }

                      Future<int> _partition(int low, int high) async {
                        int pivot = s[high];
                        int i = low - 1;
                        for (int j = low; j < high && run; j++) {
                          await Future.delayed(const Duration(microseconds: 1000));
                          if (s[j] < pivot) {
                            i++;
                            setState(() {
                              _swap(i, j);
                            });
                          }
                        }
                        setState(() {
                          _swap(i + 1, high);
                        });
                        return i + 1;
                      }

                      Future<void> _quickSort(int low, int high) async {
                        if (low < high && run) {
                          int pi = await _partition(low, high);
                          await _quickSort(low, pi - 1);
                          await _quickSort(pi + 1, high);
                        }
                      }

                      await _quickSort(0, s.length - 1);
                      setState(() {
                        run = false;
                        runs[4] = false;
                      });
                    },
                  ),
                  SortAlgorithm(
                    run: runs[5],
                    title: 'Heap Sort',
                    onTap: () async {
                      setState(() {
                        run = true;
                        runs[5] = true;
                      });
                      void _swap(int i, int j) {
                        int temp = s[i];
                        s[i] = s[j];
                        s[j] = temp;
                      }

                      Future<void> _heapify(int n, int i) async {
                        int largest = i;
                        int left = 2 * i + 1;
                        int right = 2 * i + 2;
                        if (left < n && s[left] > s[largest]) {
                          largest = left;
                        }
                        if (right < n && s[right] > s[largest]) {
                          largest = right;
                        }
                        if (largest != i) {
                          setState(() {
                            _swap(i, largest);
                          });
                          await _heapify(n, largest);
                        }
                      }

                      Future<void> _heapSort() async {
                        int n = s.length;
                        for (int i = (n ~/ 2) - 1; i >= 0 && run; i--) {
                          await _heapify(n, i);
                        }
                        for (int i = n - 1; i > 0 && run; i--) {
                          await Future.delayed(const Duration(microseconds: 3000)); // Visual delay
                          setState(() {
                            _swap(0, i);
                          });
                          await _heapify(i, 0);
                        }
                      }

                      await _heapSort();
                      setState(() {
                        run = false;
                        runs[5] = false;
                      });
                    },
                  ),
                  SortAlgorithm(
                    run: runs[6],
                    title: 'Radix Sort',
                    onTap: () async {
                      setState(() {
                        run = true;
                        runs[6] = true;
                      });

                      Future<void> _countingSort(int exp) async {
                        int n = s.length;
                        List<int> output = List.filled(n, 0);
                        List<int> count = List.filled(10, 0);
                        for (int i = 0; i < n && run; i++) {
                          int index = (s[i] ~/ exp) % 10;
                          count[index]++;
                        }
                        for (int i = 1; i < 10 && run; i++) {
                          count[i] += count[i - 1];
                        }
                        for (int i = n - 1; i >= 0 && run; i--) {
                          int index = (s[i] ~/ exp) % 10;
                          int outputIndex = count[index] - 1;
                          output[outputIndex] = s[i];
                          count[index]--;
                        }
                        for (int i = 0; i < n && run; i++) {
                          await Future.delayed(const Duration(microseconds: 5000)); // Delay for visualization
                          setState(() {
                            s[i] = output[i];
                          });
                        }
                      }

                      Future<void> _radixSort() async {
                        int maxVal = s.reduce(m.max);
                        int exp = 1;
                        while (maxVal ~/ exp > 0 && run) {
                          await _countingSort(exp);
                          exp *= 10;
                        }
                      }

                      await _radixSort();

                      setState(() {
                        run = false;
                        runs[6] = false;
                      });
                    },
                  ),
                ],
              ),
            ),
            MaterialButton(
              onPressed: () {
                setState(() {
                  run = false;
                });
              },
              color: Colors.red,
              child: const Text(
                "Stop",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SortAlgorithm extends StatelessWidget {
  const SortAlgorithm({
    super.key,
    required this.title,
    required this.onTap,
    required this.run,
  });
  final String title;
  final void Function() onTap;
  final bool run;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: run ? Colors.red : Colors.cyan,
        ),
        height: 40.0,
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(10.0),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
