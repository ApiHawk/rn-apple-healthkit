declare module "rn-apple-healthkit" {
  export interface HealthKitPermissions {
    permissions: {
      read: string[];
      write: string[];
    };
  }

  export interface AppleHealthKit {
    initHealthKit(
      permissions: HealthKitPermissions,
      callback: (error: string, result: any) => void
    ): void;

    saveFood(
      options: any,
      callback: (error: string, result: any) => void
    ): void;

    saveHeartRate(
      sample: { value: number; hasArrythmia: boolean },
      callback: (error: string, result: any) => void
    ): void;

    saveBloodPressure(
      sample: { sys: number; dia: number },
      callback: (error: string, result: any) => void
    ): void;

    isAvailable(callback: (error: any, results: boolean) => void): void;

    getDateOfBirth(
      options: any,
      callback: (error: any, results: HealthDateOfBirth) => void
    ): void;

    getLatestHeight(
      options: HealthUnitOptions,
      callback: (err: string, results: HealthValue) => void
    ): void;

    getLatestWeight(
      options: HealthUnitOptions,
      callback: (err: string, results: HealthValue) => void
    ): void;

    getHeartRateSamples(
      options: HealthBloodPressureQuery,
      callback: (err: any, results: HealthHeartRateResult[]) => void
    ): void;

    getBloodPressureSamples(
      options: HealthBloodPressureQuery,
      callback: (err: any, results: HealthBloodPressureResult[]) => void
    ): void;
  }

  export interface HealthDateOfBirth {
    value: string;
    age: number;
  }

  export interface HealthValue {
    value: number;
    startDate: string;
    endDate: string;
  }

  export interface HealthUnitOptions {
    unit: HealthUnit;
  }

  export interface HealthBloodPressureQuery {
    unit?: HealthUnit;
    startDate: string; // required
    endDate?: string; // optional; default now
    ascending?: boolean; // optional; default false
    limit?: number; // optional; default no limit
  }

  export interface HealthBloodPressureResult {
    bloodPressureSystolicValue: number;
    bloodPressureDiastolicValue: number;
    startDate: string;
    endDate: string;
    metadata?: { [key: string]: any };
  }

  export interface HealthHeartRateResult {
    value: number;
    startDate: string;
    endDate: string;
    metadata?: { [key: string]: any };
  }

  export enum HealthUnit {
    bpm = "bpm",
    calorie = "calorie",
    celsius = "celsius",
    count = "count",
    day = "day",
    fahrenheit = "fahrenheit",
    foot = "foot",
    gram = "gram",
    hour = "hour",
    inch = "inch",
    joule = "joule",
    meter = "meter",
    mgPerdL = "mgPerdL",
    mile = "mile",
    minute = "minute",
    mmhg = "mmhg",
    mmolPerL = "mmolPerL",
    percent = "percent",
    pound = "pound",
    second = "second"
  }

  const appleHealthKit: AppleHealthKit;
  export default appleHealthKit;
}
