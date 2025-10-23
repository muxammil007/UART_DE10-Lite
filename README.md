🛰️ UART Communication on DE10-Lite FPGA

This project implements a UART (Universal Asynchronous Receiver/Transmitter) communication system on the Intel DE10-Lite FPGA. The design is written in Verilog and demonstrates both data transmission and echo reception over a serial interface.

🔧 Project Overview

On startup, the FPGA automatically transmits the message "HELLO" over the UART interface.

After initialization, the FPGA continuously echoes back any characters received from the connected terminal or keyboard input.

The design uses a baud rate generator to create timing ticks for UART transmission and reception.

It includes separate modules for:

UART Transmitter

UART Receiver

Baud Rate Generator

Top-Level Integration (uart_echo.v)

🖥️ Hardware Setup

Board: DE10-Lite (Intel MAX 10 FPGA)

Clock: 50 MHz

UART Interface:

TX → Arduino_IO1 (PIN_AB6)

RX → Arduino_IO0 (PIN_AB5)

🧩 Features

Fully functional UART TX/RX implementation in Verilog

Configurable baud rate

Clean, modular, and easy-to-understand code

Ideal for learning FPGA-based serial communication

🧠 How It Works

On reset, the system transmits "HELLO\r\n" to the terminal.

The receiver module waits for user input.

Each received byte is sent back to the terminal — simple echo functionality.

🚀 Usage

Load the bitstream onto the DE10-Lite board.

Open a serial terminal (e.g., PuTTY, Tera Term) with the correct COM port and baud rate (e.g., 9600).

Observe the “HELLO” message.

Type any text — it will echo back to you in real time.
