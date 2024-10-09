# MARIO

A flexible self constructing data pipeline framework.
Program calls are logged at runtime for easy and accurate documentation.
Rapidly add and edit parameters.
Skip and reorder steps without editing code.

#### Contact
steven.douglas.holdenHATgmail.com

## Parameters

After cloning the repository edit the parameters document

#### Base Parameters

Parameter Specifications

pipeName: enter a string with no spaces which will be added to the main logfile and other output locations.

steps: on a single line enter a series of strings separated by single spaces. Each step will be executed in order.

refGen: the full path from root to the reference genome, this parameter has been exported to the environment and is available as ${refGen} from any call.

refType: the filetype of the reference genome. If refGen.fasta then 'fasta', do not include the '.' Exported and available as ${refType}

newLog: If set to 'Y' the previous main logfile will be erased. Any other value will append the logfile of each run to the previous.

Globally Available

refName:  from any call, ${refName} will evaluate to a string, 'referenceGenomeV1 ' if the varible refGen is /path/to/referenceGenomeV1.refType

timeStamp: from any call, ${timeStamp} will evaluate to the time at beginning of the run, formatted as %Y%m%d_%H%M

logNum: from any call, ${logNum} will evaluate to the numeric value of the step in sequence, base 1.

#### Add Parameters
Edit the parameter document, add a line following the format

	parameterName=value
Edit the mario.sh script, in the section `#global variables set from parameter document` add a line following the format

	export parameterName=$(eval parameterName; echo ${varValues[$?]})
Using the export command makes the variable available to the child calls of the Mario script.  as `${parameterName}`
The parameter is not available to an isolated call, but only when called by the Mario script.
For all lines of the parameters document the equals(=) character indicates a parameter, triggers the evaluation processes and should not be followed by a space.

#### Steps Parameter
When modifying the steps parameter, first add step names, then run the pipeline once to initialize the calls.
Generic calls with the specified names will be created in the call directory.
For each stepName.sh script in the call directory, add the command details.
Comands written between <CALL> <PARAMETERS> will be extracted at runtime and reported to the main logfile.
The generic call assumes the runtime location to be the data directory.

On each run the step sequence is reported as a long file name in the call directory as a handy reference. Listing the contents of the dir with `ls -1` will display this more clearly.

'genericCall.sh' exists as a template for a new step. Before each run, if the steps parameter has an new unskipped stepName,
a copy will be made of genericCall.sh with the new call's stepName.sh

'genericStop.sh' exists as a template for a step where you want pipeline execution to halt and wait for user observation. Include 'Stop' in the step name string, eg. 'checkDataStop' the steps sequence and the stop name will be displayed to inform the user of the progress.

## Usage

1. set steps
1. run `./Mario.sh` once
1. enter call specifics
1. run Mario

#### Modify Step Order
Reorder the execution sequence by rearranging the order of the steps parameter
#### Skip a Step
To skip a step or a series of steps, add a '#' before the stepName eg. `#stepName`
In the event that a pipeline has partially completed a run, skip the series of sucessfully completed steps
#### Add a Step
Mask other steps with '#', add the newStep in sequence to the step parameter, run Mario once, modify the call settings, unmask the steps in the step parameter, run Mario.
#### Add a Stop
Similar to adding a step but the name must include 'Stop'
Mask other steps with '#', add the newStop in sequence to the step parameter, run Mario once, unmask the steps in the step parameter, run Mario.
A stop will allow the user to modify any downstream call parameters that are dependant on data states. The genericStop also allows an exit from the pipeline.

## Logging

The Mario pipeline produces a progress logfile that reports step progression and status, files produced, processing times, the specifics of each call as set at runtime, making documentation for any pipeline easy.

Mario also automatically outputs a set of enumerated logs for each step.
To log only call errors retain the `2> ../log${stepNum}_${name}STDERR` line directly after the program call.
To log the complete output replace this line with `&> ../log${stepNum}_${name}`

Individual step logs will be overwritten if that step is run again.

#### Reporting Files
The logfile has a count and report of the files produced by each step, this works in most cases.
Named file reporting is not perfect as it depends on pattern matching the old data contents to the new.
If a new file name matches part or all of a previous file, it's name will not be reported.
eg. if previousFile.type exists in data, a new File.type will match and not be reported but it will be counted.
If the count of files produced differs from the count of file names displayed then this is occuring and you should check in data to identify the output.

While debugging environment and calls, setting newLog=Y prevents a buildup of irrelevant run logs.


Mario Christmas :)

```
                            . '  ' .
                          '    /\    '
                         +   ' || '   +
                            |\ || /|
                       ' - . \\||// . - '
                        -= <>>>><<<<> =-
                       . - ' //||\\ ' - .
                            |/ || \|
                         +   . || .   +
                          .    ||    .
                            ' .||. '
                               \/

                               /\
                              //\\
                             //||\\
                            // || \\
                           //\ || /\\
                          //'.\||/.'\\
                         //___>  <___\\
                        //------------\\
                       //              \\
                      //          .-"-. \\
                     //          (  (`\) \\
                    //            '-/| `\ \\
                   //  .-"-.       / |  || \\
                  //  (.-.  )     /  |  ||  \\
                   || / /)-'     =`-.|  || ||
                   ||/ / '-| .-""-.  | =\| ||
                   |/  |'./ (__()__) |   | ||
                   /   /\====\    /==|   |=||
                  /_.-'  |    >--<   |-.-| ||
                   |----'            `-.-' ||


```
