Baby Steps in Bluespec
----------------------

```
bsc -sim -g testbench -u testbench.bsv 
bsc -sim -e testbench
./a.out
```

```
bsc -verilog machine01.bsv 
python testbench.py
```

```
bsc -verilog Comp.bsv
python testcomp.py
```

## Misc. Links

- [example of pyverilator from Koika](https://github.com/mit-plv/koika/blob/master/examples/rv/etc/rvcore.pyverilator.py)
