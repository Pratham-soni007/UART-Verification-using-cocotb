# tests/uart_gen.py
#generating random cases
import random

def generate_test_cases(n_random=20):
    cases = []

    # Edge cases - always include these
    edge = [0x00, 0xFF, 0xA5, 0x5A, 0x01, 0x80, 0xFE, 0x7F]
    for val in edge:
        cases.append({
            "data"     : val,
            "category" : "edge",
            "expected" : val
        })

    # Random cases
    for _ in range(n_random):
        val = random.randint(0, 255)
        cases.append({
            "data"     : val,
            "category" : "random",
            "expected" : val
        })

    return cases


def generate_fifo_stress(depth=8):
    """Generate a sequence that fills FIFO to test full/empty flags"""
    return [random.randint(0, 255) for _ in range(depth)]


if __name__ == "__main__":
    cases = generate_test_cases()
    print(f"Generated {len(cases)} test cases")
    for c in cases:
        print(f"  [{c['category']}] 0x{c['data']:02X}")
