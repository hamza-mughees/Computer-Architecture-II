#include <iostream>
#include "stdio.h"
#include "time.h"

int compute_pascal(int, int);
int max(int, int);

int n_proc_calls,
    depth, max_depth,
    overflows,
    underflows,
    n_active_windows,
    n_overlapping_register_windows,
    n_register_windows_pushed,
    n_windows_to_check;

int compute_pascal(int row, int position) {
    n_proc_calls++;

    depth++;
    max_depth = max(depth, max_depth);

    if (n_active_windows == n_windows_to_check)
        overflows++;
    else n_active_windows++;

    if (position == 1 || position == row) {
        depth--;
        if (n_active_windows <= 2)
            underflows++;
        else n_active_windows--;
        return 1;
    }

    int valAtRowPos = compute_pascal(row - 1, position) + compute_pascal(row - 1, position - 1);
    depth--;
    if (n_active_windows <= 2)
        underflows++;
    else n_active_windows--;

    return valAtRowPos;
}

int max(int a, int b) {
    if (a > b)
        return a;
    return b;
}

void print_pascal_traits(int row, int position, int n_orw, bool modified) {
    n_proc_calls = 0;
    depth = 0;
    max_depth = 0;
    overflows = 0;
    underflows = 0;
    n_active_windows = 0;
    n_overlapping_register_windows = n_orw;
    n_register_windows_pushed = 0;
    n_windows_to_check = modified ? n_overlapping_register_windows-1 : n_overlapping_register_windows;

    clock_t start = clock();
    int num = compute_pascal(row, position);
    clock_t end = clock();

    double time = end - start;

    std::cout << "Overlapping regsiter windows: " << n_overlapping_register_windows << std::endl;
    std::cout << "Time: " << time << "ms" << std::endl;
    std::cout << "Procedure calls: " << n_proc_calls << std::endl;
    std::cout << "Maximum register window depth: " << max_depth << std::endl;
    std::cout << "Register window overflows: " << overflows << std::endl;
    std::cout << "Register window underflows: " << underflows << "\n" << std::endl;
}

int main() {
    std::cout << "Original (utilising all register windows):\n" << std::endl;
    print_pascal_traits(30, 20, 6, false);
    print_pascal_traits(30, 20, 8, false);
    print_pascal_traits(30, 20, 16, false);

    std::cout << "Modified (leaving one empty register window):\n" << std::endl;
    print_pascal_traits(30, 20, 6, true);
    print_pascal_traits(30, 20, 8, true);
    print_pascal_traits(30, 20, 16, true);
}

/*
The lower the threshold for the amount of utilized register windows, the higher the amount of overflows and underflows.
*/
