module testbench();

    logic [127:0] data_to_cipher [11];
    logic [127:0] ciphered_data  [11];
    logic clk, resetn, request, ack, valid, busy;
    logic [127:0] data_i, data_o;

    initial clk <= 0;

    always #5ns clk <= ~clk;

    integer i = 0;
    logic [128*11-1:0] print_str;

    kuznechik_cipher DUT(
        .clk_i      (clk),
        .resetn_i   (resetn),
        .data_i     (data_i),
        .request_i  (request),
        .ack_i      (ack),
        .data_o     (data_o),
        .valid_o    (valid),
        .busy_o     (busy)
    );

    initial begin
        data_to_cipher[00] <= 128'ha5ff3b17aa3368ffeda5d628bc671622;
        data_to_cipher[01] <= 128'he904aa20ef22c3da79c9c6c9d3d55fe1;
        data_to_cipher[02] <= 128'hd623f2793d67c95ae522c6312ebcfb5e;
        data_to_cipher[03] <= 128'h1967883eab850ddeed1f73c2ce95f7b3;
        data_to_cipher[04] <= 128'hc919ab81a141d5e39c6d2508915fd106;
        data_to_cipher[05] <= 128'ha65b9b6b797522ca22cf329ed3cf4a5b;
        data_to_cipher[06] <= 128'h5a63978616f289cb9c914282680692a6;
        data_to_cipher[07] <= 128'h9fd7d005aa64e9466d5e5b3a07ee4b71;
        data_to_cipher[08] <= 128'h81c9a15524b07b7eab9def4d8709f050;
        data_to_cipher[09] <= 128'hca103ce2b8af57b8033b5973051ead4c;
        data_to_cipher[10] <= 128'hea89bd191958c6bf0d2890ded315cd5d;
        $display("Testbench has been started.\nResetting");
        resetn <= 1'b0;
        ack <= 0;
        request <= 0;
        repeat(2) begin
            @(posedge clk);
        end
        resetn <= 1'b1;
        for(i=0; i < 11; i++) begin
            $display("Trying to cipher %d chunk of data", i);
            @(posedge clk);
            data_i <= data_to_cipher[i];
            while(busy) begin
                @(posedge clk);
            end
            request <= 1'b1;
            @(posedge clk);
            request <= 1'b0;
            while(~valid) begin
                @(posedge clk);
            end
            ciphered_data[i] <= data_o;
            ack <= 1'b1;
            @(posedge clk);
            ack <= 1'b0;
        end
        $display("Ciphering has been finished.");
        $display("============================");
        $display("===== Ciphered message =====");
        $display("============================");
        print_str = {ciphered_data[0],
                        ciphered_data[1],
                        ciphered_data[2],
                        ciphered_data[3],
                        ciphered_data[4],
                        ciphered_data[5],
                        ciphered_data[6],
                        ciphered_data[7],
                        ciphered_data[8],
                        ciphered_data[9],
                        ciphered_data[10]
                    };
        $display("%s", print_str);
        $display("============================");
        $finish();
    end

endmodule
