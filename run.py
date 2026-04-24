# run.py
import os
from pathlib import Path
from cocotb.runner import get_runner

def run():
    sim = os.getenv("SIM", "icarus")
    runner = get_runner(sim)

    runner.build(
        verilog_sources=[
            Path("rtl/baud_rate_gen.v"),
            Path("rtl/transmitter.v"),
            Path("rtl/receiver.v"),
            Path("rtl/sync_fifo.v"),
            Path("rtl/uart_top.v"),
        ],
        hdl_toplevel="uart_top",
        always=True,
    )

    runner.test(
        hdl_toplevel="uart_top",
        test_module="tests.test_uart",
    )

if __name__ == "__main__":
    run()
