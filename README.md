# LAST_Handle

The Mother of all LAST classes. It inerits from the Matlab class `handle`, and supplements it with
utility methods, for example to handle configurations and to list hidden properties.

All drivers and abstractors inherit from it.

This package depends on:

+ **AstroPack**  for the configuration and logging methods;

Requires Matlab >= **2019b** for the use of the clause `arguments`

## obs.remoteClass and LAST_Handle.classCommand

A dummy class pointing to classes defined in a remote session, and a simple mechanism to access
methods and properly of indifferently local or remote classes.

### example:

#### Session 1

```
M1=obs.util.Messenger('localhost',50000,50001)
M1.connect
Q=inst.QHYccd;
classCommand(Q,'CamStatus')
```
#### Session 2

```
M2=obs.util.Messenger('localhost',50001,50000)
M2.connect
R=obs.remoteClass('Q',M2)
classCommand(R,'CamStatus')
```
