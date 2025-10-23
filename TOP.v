module TOP(
    input        Clk,
    input        Rst_n,
    input        Rx,
    output       Tx,
    output [7:0] RxData
);

/////////////////////////////////////////////////////////////////////////////////////////
// Internal signals
/////////////////////////////////////////////////////////////////////////////////////////
wire [7:0] TxData;
wire       RxDone;
wire       TxDone;
wire       tick;
wire       RxEn;
wire [3:0] NBits;
wire [15:0] BaudRate;

reg        TxEn_reg;
reg  [7:0] data_array [4:0];        // "HELLO"
reg  [2:0] data_index;
reg        sending_hello;
reg  [15:0] char_delay_counter;
reg        loopback_mode;
reg  [7:0] TxData_reg;

// *** FIXED: EDGE DETECTION FOR SINGLE ECHO ***
reg        rx_done_prev;            // Previous RxDone state
reg        rx_edge_detected;        // SINGLE pulse on rising edge
reg        echo_in_progress;        // Block new echoes during TX

/////////////////////////////////////////////////////////////////////////////////////////
// Assignments
/////////////////////////////////////////////////////////////////////////////////////////
assign RxEn     = 1'b1;
assign BaudRate = 16'd325;          // 50MHz/9600
assign NBits    = 4'b1000;          // 8-bit data
assign TxData   = TxData_reg;
assign TxEn     = TxEn_reg;

/////////////////////////////////////////////////////////////////////////////////////////
// Initialize HELLO array
/////////////////////////////////////////////////////////////////////////////////////////
initial begin
    data_array[0] = 8'h48; // 'H'
    data_array[1] = 8'h45; // 'E'
    data_array[2] = 8'h4C; // 'L'
    data_array[3] = 8'h4C; // 'L'
    data_array[4] = 8'h4F; // 'O'
end

/////////////////////////////////////////////////////////////////////////////////////////
// Control logic: First send HELLO, then SINGLE echo per keypress
/////////////////////////////////////////////////////////////////////////////////////////
always @(posedge Clk or negedge Rst_n) begin
    if (!Rst_n) begin
        data_index         <= 3'd0;
        TxEn_reg           <= 1'b0;
        sending_hello      <= 1'b1;
        char_delay_counter <= 16'd0;
        loopback_mode      <= 1'b0;
        TxData_reg         <= 8'd0;
        rx_done_prev       <= 1'b0;
        rx_edge_detected   <= 1'b0;
        echo_in_progress   <= 1'b0;
    end else begin
        rx_done_prev   <= RxDone;           // Track previous state
        rx_edge_detected <= 1'b0;           // Default: no edge
        
        // *** EDGE DETECTION: Only trigger ONCE per RxDone ***
        if (RxDone && !rx_done_prev) begin
            rx_edge_detected <= 1'b1;       // SINGLE PULSE!
        end
        
        if (sending_hello) begin
            // --- Sending HELLO (UNCHANGED) ---
            if (!TxEn_reg && !TxDone && char_delay_counter == 16'd0) begin
                TxData_reg     <= data_array[data_index];
                TxEn_reg       <= 1'b1;
                char_delay_counter <= 16'd10415;  // ~1ms delay
            end 
            else if (TxEn_reg && TxDone) begin
                TxEn_reg <= 1'b0;
            end
            else if (char_delay_counter > 0) begin
                char_delay_counter <= char_delay_counter - 1;
                if (char_delay_counter == 16'd1) begin
                    if (data_index < 3'd4) begin
                        data_index <= data_index + 1;
                    end else begin
                        data_index      <= 3'd0;
                        sending_hello   <= 1'b0;
                        loopback_mode   <= 1'b1;
                    end
                end
            end
            
        end else if (loopback_mode) begin
            // *** PERFECT SINGLE ECHO LOGIC ***
            
            // Step 1: CAPTURE DATA on RISING EDGE (ONCE per keypress)
            if (rx_edge_detected && !echo_in_progress) begin
                TxData_reg     <= RxData;       // Capture data
                echo_in_progress <= 1'b1;       // Block new echoes
            end
            
            // Step 2: START TRANSMISSION when TX is idle
            if (echo_in_progress && !TxEn_reg) begin
                TxEn_reg <= 1'b1;
            end
            
            // Step 3: TX COMPLETE → READY FOR NEXT KEY
            if (TxEn_reg && TxDone) begin
                TxEn_reg       <= 1'b0;
                echo_in_progress <= 1'b0;       // *** READY FOR NEXT KEY! ***
            end
        end
    end
end

/////////////////////////////////////////////////////////////////////////////////////////
// Instantiate modules
/////////////////////////////////////////////////////////////////////////////////////////
UART_rs232_rx I_RS232RX(
    .Clk(Clk),
    .Rst_n(Rst_n),
    .RxEn(RxEn),
    .RxData(RxData),
    .RxDone(RxDone),
    .Rx(Rx),
    .Tick(tick),
    .NBits(NBits)
);

UART_rs232_tx I_RS232TX(
    .Clk(Clk),
    .Rst_n(Rst_n),
    .TxEn(TxEn),
    .TxData(TxData),
    .TxDone(TxDone),
    .Tx(Tx),
    .Tick(tick),
    .NBits(NBits)
);

UART_BaudRate_generator I_BAUDGEN(
    .Clk(Clk),
    .Rst_n(Rst_n),
    .Tick(tick),
    .BaudRate(BaudRate)
);

endmodule