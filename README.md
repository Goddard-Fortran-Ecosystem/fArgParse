Real documentation is sorely needed here.

## Example: (from pFUnit)

```f90
 use fArgParse

 type(ArgParser), target :: parser
 type (StringUnlimitedMap) :: options
 logical :: debug

 ...
 
 parser = ArgParser()
 call parser%add_argument('-d', '-v', '--debug', '--verbose', action='store_true', &
      & help='make output more verbose')

 call parser%add_argument('-f', '--filter', action='store', &
      & help='only run tests that match pattern')
 
 call parser%add_argument('-o', '--output', action='store', &
      & help='only run tests that match pattern')

 call parser%add_argument('-r', '--runner', action='store', default='TestRunner', &
      & help='use non-default runner run tests')

 call parser%add_argument('-s', '--skip', type='integer', &
      & dest='n_skip', action='store', default=0, &
      & help='skip the first n_skip tests; only used with RemoteRunner')

 call parser%add_argument('-t', '--tap', type='string', &
      & dest='tap_file', action='store', default=0, &
      & help='add a TAP listener and send results to file name')

 ...
 option => options%at('debug')
 if (associated(option)) then
    call cast(option, debug)
    if (debug) call runner%add_listener(DebugListener(unit))
 end if

```

### Buit in help:

```script
./my_exe -h
 usage: ./tests/Vector/vector_tests [-h][-d][-f FILTER][-o OUTPUT][-r RUNNER][-s N_SKIP][-t TAP_FILE]
  
 optional arguments:
  -h, --help                 This message.
  -d, --debug, --verbose     make output more verbose
  -f, --filter               only run tests that match pattern
  -o, --output               only run tests that match pattern
  -r, --runner               use non-default runner run tests
  -s, --skip                 skip the first n_skip tests; only used with RemoteRunner
  -t, --tap                  add a TAP listener and send results to file name
```
