model IncompleteZombieApocalypse "Incomplete zombie apocalypse model"
  // Define types, parameters and variables, as well as start values
  // ...
initial equation
  der(H) = 0;
  I=0;
  Z=0;
  D=0;
equation
  // The equations of the model
  // ...
  annotation(experiment(StartTime=0, StopTime=8640000, Tolerance=1e-6));
end IncompleteZombieApocalypse;
