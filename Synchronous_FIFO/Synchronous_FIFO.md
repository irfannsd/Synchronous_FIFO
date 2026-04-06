
# Entity: Sync_FIFO 
- **File**: Synchronous_FIFO.v

## Diagram
![Diagram](Sync_FIFO.svg "Diagram")
## Generics

| Generic name | Type | Value | Description |
| ------------ | ---- | ----- | ----------- |
| DEPTH        |      | 8     |             |
| WIDTH        |      | 8     |             |

## Ports

| Port name | Direction | Type             | Description |
| --------- | --------- | ---------------- | ----------- |
| clk       | input     | wire             |             |
| rst       | input     | wire             |             |
| wr_en     | input     | wire             |             |
| rd_en     | input     | wire             |             |
| data_in   | input     | wire [WIDTH-1:0] |             |
| data_out  | output    | [WIDTH-1:0]      |             |
| full      | output    | wire             |             |
| empty     | output    | wire             |             |

## Signals

| Name             | Type              | Description |
| ---------------- | ----------------- | ----------- |
| w_ptr            | reg [PTR_WIDTH:0] |             |
| r_ptr            | reg [PTR_WIDTH:0] |             |
| Fifo [0:DEPTH-1] | reg [WIDTH-1:0]   |             |

## Constants

| Name      | Type | Value   | Description |
| --------- | ---- | ------- | ----------- |
| PTR_WIDTH |      | (DEPTH) |             |

## Processes
- unnamed: ( @(posedge clk) )
  - **Type:** always
- unnamed: ( @(posedge clk) )
  - **Type:** always
