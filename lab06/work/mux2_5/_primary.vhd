library verilog;
use verilog.vl_types.all;
entity mux2_5 is
    port(
        d0              : in     vl_logic_vector(4 downto 0);
        d1              : in     vl_logic_vector(4 downto 0);
        s               : in     vl_logic;
        y               : out    vl_logic_vector(4 downto 0)
    );
end mux2_5;
