library verilog;
use verilog.vl_types.all;
entity flopr is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        d               : in     vl_logic_vector(31 downto 0);
        q               : out    vl_logic_vector(31 downto 0)
    );
end flopr;
