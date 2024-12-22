# projet-c-wyre
To launch the program, download all the files in the github. Then wright this command in your terminal: 
  bash c-wire.sh [name of the csv file / filepath] [station type] [consumer type] [option] 
  exemple: bash c-wire.sh c_wire_v00.dat lv all
argument:
  [name of the csv file / filepath]:  filepath of the data base
                                      expected extension: .csv .dat
                                      separator: ;
  [station type]:    the type of sation that you want to focus on.
                     expected value: hvb hva lv
  [consumer type]:   the type of consumer that you want to focus on.
                     expected value: comp indiv all 
options: 
  [central number]: the number of the central that you want to focus on, if this option isn't added the program considers all the stations.
  -h : add this option to stop the program and opens a txt file that explain how to use the program.
