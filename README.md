
🛰️ UART Communication on DE10-Lite FPGA
======================================

This project implements a UART (Universal Asynchronous Receiver/Transmitter) communication system on the Intel DE10-Lite FPGA. 
It demonstrates a simple yet effective serial communication setup that first sends "HELLO" upon startup and then echoes back any characters typed from the keyboard via a serial terminal.

🔧 Project Overview
-------------------
- On startup, the FPGA transmits the message "HELLO" over UART.
- Afterwards, it continuously echoes back every character received from the terminal.
- Includes dedicated Verilog modules for:
  - UART Transmitter
  - UART Receiver
  - Baud Rate Generator
  - Top-Level Integration (TOP.v)
- Designed for clarity, modularity, and learning of UART concepts in FPGA design.

🖥️ Hardware Setup
------------------
- Board: Intel DE10-Lite (MAX 10 FPGA)
- System Clock: 50 MHz
- UART Interface: TX → Arduino_IO1 (PIN_AB6), RX → Arduino_IO0 (PIN_AB5)
- Baud Rate: Configurable (default: 9600 bps)

🧠 How It Works
----------------
1. On reset, the FPGA sends "HELLO" to the serial terminal.
2. The UART receiver waits for keyboard input.
3. Any received byte is instantly sent back to the terminal — implementing echo functionality.

🚀 Usage
---------
1. Clone this repository: git clone https://github.com/muxammil007/UART_DE10-Lite
2. Open the project in Intel Quartus Prime.
3. Compile and program the bitstream onto the DE10-Lite board.
4. Open a serial terminal (e.g., PuTTY, Tera Term) with:
   - Baud Rate: 9600
   - Data Bits: 8
   - Stop Bits: 1
   - Parity: None
5. You should see "HELLO" on the terminal.
6. Type any character — it will echo back instantly!

📁 File Structure
-----------------
TOP.v         	  			- Top-Level Integration
UART_tx.v           			- UART Transmitter Module
UART_rx.v           			- UART Receiver Module
UART_baudrate_generator.v          	- Baud Rate Generator
TOP.qsf     				 - Pin Assignments for DE10-Lite
README.md           			- Project Documentation

👨‍💻 Author
------------
Muhammad Muzammil  
Embedded & AI Engineer | FPGA & Microcontroller Enthusiast  
LinkedIn: https: www.linkedin.com/in/muzammil-arshad
GitHub: https: https://github.com/muxammil007

“Simple UART communication — the foundation for many FPGA-based embedded systems.”

