module FullAdder(input A, input B, input C, output S, output Cout);

assign {Cout, S} = A + B + C;

endmodule