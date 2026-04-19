# test.py — Verify: python-mode or python-ts-mode, 4-space indent, no tabs

from dataclasses import dataclass
from typing import Optional


@dataclass
class Point:
    x: float
    y: float
    label: Optional[str] = None


def distance(a: Point, b: Point) -> float:
    """Calculate Euclidean distance between two points."""
    return ((a.x - b.x) ** 2 + (a.y - b.y) ** 2) ** 0.5


def main():
    points = [
        Point(0, 0, "origin"),
        Point(3, 4),
    ]
    for p in points:
        d = distance(p, Point(0, 0))
        print(f"{p.label or 'unnamed'}: {d:.2f}")


if __name__ == "__main__":
    main()
