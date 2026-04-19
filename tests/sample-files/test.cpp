// test.cpp — Verify: c++-mode or c++-ts-mode, 4-space indent, no tabs
#include <iostream>
#include <vector>
#include <string>

template<typename T>
class Container {
public:
    void add(const T& item) {
        items_.push_back(item);
    }

    void print() const {
        for (const auto& item : items_) {
            std::cout << item << "\n";
        }
    }

private:
    std::vector<T> items_;
};

int main() {
    Container<std::string> c;
    c.add("hello");
    c.print();
    return 0;
}
