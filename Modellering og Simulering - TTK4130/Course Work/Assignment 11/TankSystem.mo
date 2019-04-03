package TankSystem
  import TankSystem;

  model TankLevelPIDSystem
    TankSystem.LiquidSource source(flowLevel = 0.02, perAmplitude = 0.005, perFrequency = 0.001, timeConstant = 10);
    TankSystem.LiquidSource noFlowIn1(flowLevel = 0);
    TankSystem.LiquidSource noFlowIn2(flowLevel = 0);
    TankSystem.OpenTank tank1(area = 1.5, h0 = 0, flowGain = 0.05, maxV = 10);
    TankSystem.OpenTank tank2(area = 1.0, h0 = 0, flowGain = 0.05, maxV = 10);
    TankSystem.PIDController levelController1(ref = 0.25, K = 10, Ti = 500, Td = 10);
    TankSystem.PIDController levelController2(ref = 0.40, K = 10, Ti = 500, Td = 10);
  equation
    connect(source.qOut, tank1.qInFromSource);
    connect(noFlowIn1.qOut, tank1.qInFromTank);
    connect(tank1.tSensor, levelController1.cIn);
    connect(tank1.tActuator, levelController1.cOut);
    connect(noFlowIn2.qOut, tank2.qInFromSource);
    connect(tank1.qOut, tank2.qInFromTank);
    connect(tank2.tSensor, levelController2.cIn);
    connect(tank2.tActuator, levelController2.cOut);
  end TankLevelPIDSystem;

  block LiquidSource
    constant Real pi = 2 * Modelica.Math.asin(1.0);
    TankSystem.LiquidFlow qOut;
    parameter Real flowLevel = 0;
    parameter Real perAmplitude = 0;
    parameter Real perFrequency = 0;
    parameter Real timeConstant = 1;
    parameter Real flowLevel0 = 0;
    parameter Real derFlowLevel0 = 0;
    Real x1 (start = flowLevel0);
    Real x2 (start = derFlowLevel0);
    Real A;
  algorithm
    A := 2 * pi * timeConstant * perFrequency;
    A := sqrt((1 - A ^ 2) ^ 2 + (2 * A) ^ 2);
    A := perAmplitude / A;
  equation
    der(x1) = x2;
    timeConstant ^ 2 * der(x2) + 2 * timeConstant * x2 + x1 = A * sin(2 * pi * perFrequency * time) + flowLevel;
    qOut.vFlow = x1;
  end LiquidSource;

  block OpenTank
    TankSystem.SensorSignal tSensor;
    TankSystem.ValveActuatorSignal tActuator;
    TankSystem.LiquidFlow qInFromSource;
    TankSystem.LiquidFlow qInFromTank;
    TankSystem.LiquidFlow qOut;
    parameter Real area = 1;
    parameter Real flowGain = 0;
    parameter Boolean measureLevel = true;
    parameter Real minV = 0;
    parameter Real maxV = 0;
    parameter Real h0 = 1;
    Real h (start = h0);
  equation
    der(h) = if h>=0 then (qInFromSource.vFlow + qInFromTank.vFlow - qOut.vFlow) / area else 0;
    qOut.vFlow = LimitValue(minV, maxV, -flowGain * tActuator.valvePosition);
    tSensor.measurement = h;
  end OpenTank;

  partial block BaseController
    TankSystem.SensorSignal cIn;
    TankSystem.ValveActuatorSignal cOut;
    parameter Real ref = 0;
    parameter Real K = 0;
    parameter Real Ti = 1;
    parameter Real Td = 0;
    Real controlOutput;
    Real error;
    Real x1;
    Real x2;
  equation
    error = ref - cIn.measurement;
    cOut.valvePosition = controlOutput;
  end BaseController;

  block PIDController
    extends TankSystem.BaseController;
  equation
    Ti * der(x1) = error;
    x2 = Td * der(error);
    controlOutput = K * (error + x1 + x2);
  end PIDController;

  connector LiquidFlow
    Real vFlow;
  end LiquidFlow;

  connector SensorSignal
    Real measurement;
  end SensorSignal;

  connector ValveActuatorSignal
    Real valvePosition;
  end ValveActuatorSignal;

  function LimitValue
    input Real vMin;
    input Real vMax;
    input Real v;
    output Real vLim;
  algorithm
    vLim := if v > vMax then vMax else if v < vMin then vMin else v;
  end LimitValue;

  annotation(
    uses(Modelica(version = "3.2.2")));
end TankSystem;
