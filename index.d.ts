declare module 'rn-apple-healthkit' {
  export interface HealthKitPermissions {
    permissions: {
      read: HealthPermission[]
      write: HealthPermission[]
    }
  }

  export interface AppleHealthKit {
    initHealthKit(
      permissions: HealthKitPermissions,
      callback: (error: string, result: any) => void
    ): void

    saveHeartRate(
      sample: { value: number; hasArrhythmia: boolean },
      callback: (error: string, result: any) => void
    ): void

    saveBloodPressure(
      sample: { sys: number; dia: number },
      callback: (error: string, result: any) => void
    ): void

    deleteBloodPressureSample(sampleId: string, callback: (error: string, result: any) => void)

    isAvailable(callback: (error: any, results: boolean) => void): void

    getLatestHeight(
      options: HealthUnitOptions,
      callback: (err: string, results: HealthValue) => void
    ): void

    saveHeight(
      options: { value: number; unit: HealthUnit},
      callback: (error: string, result: any) => void
    ): voidk

    getLatestWeight(
      options: HealthUnitOptions,
      callback: (err: string, results: HealthValue) => void
    ): void

    saveWeight(
      options: { value: number; unit: HealthUnit},
      callback: (error: string, result: any) => void
    ): voidk

    getHeartRateSamples(
      options: HealthBloodPressureQuery,
      callback: (err: any, results: HealthHeartRateResult[]) => void
    ): void

    getBloodPressureSamples(
      options: HealthBloodPressureQuery,
      callback: (err: any, results: HealthBloodPressureResult[]) => void
    ): void

    getBiologicalSex(
      input: null,
      callback: (err: any, result: HealthBiologicalSexResult) => void
    ): void

    getDateOfBirth(
      input: null,
      callback: (err: any, result: HealthDateOfBirth) => void
    ): void

    getSleepSamples(
      query: HealthGenericQuery,
      callback: (err: any, result: HealthValue[]) => void
    )

    getDailyStepCountSamples(
      query: HealthGenericQuery,
      callback: (err: any, result: HealthValue[]) => void
    )

    checkWritePermissions(callback: (err: any, result: HealthWritePermissions) => void)

    Constants: {
      Permissions: { [key in keyof HealthPermission]: HealthPermission }
      Units: { [key in keyof HealthUnit]: HealthUnit }
    }
  }

  export interface HealthDateOfBirth {
    value: string
    age: number
  }

  export interface HealthValue {
    value: number
    startDate: string
    endDate: string
  }

  export interface HealthUnitOptions {
    unit: HealthUnit
  }

  export interface HealthBloodPressureQuery {
    unit?: HealthUnit
    startDate: string // required
    endDate?: string // optional; default now
    ascending?: boolean // optional; default false
    limit?: number // optional; default no limit
  }

  export interface HealthGenericQuery {
    startDate: string // required
    endDate?: string // optional; default now
    limit?: number // optional; default no limit
  }

  export interface HealthBloodPressureResult {
    id: string
    systolic: number
    diastolic: number
    startDate: string
    endDate: string
    metadata?: { [key: string]: any }
    source: string
  }

  export interface HealthHeartRateResult {
    id: string
    value: number
    startDate: string
    endDate: string
    metadata?: { [key: string]: any }
    source: string
  }

  export interface HealthWritePermissions {
    systolic: boolean
    diastolic: boolean
    heartRate: boolean
  }

  export interface HealthBiologicalSexResult {
    value: 'unknown' | 'male' | 'female' | 'other'
  }

  export type HealthUnit = {
    bpm: 'bpm'
    calorie: 'calorie'
    celsius: 'celsius'
    count: 'count'
    day: 'day'
    fahrenheit: 'fahrenheit'
    foot: 'foot'
    gram: 'gram'
    hour: 'hour'
    inch: 'inch'
    joule: 'joule'
    meter: 'meter'
    cm: 'cm'
    mgPerdL: 'mgPerdL'
    mile: 'mile'
    minute: 'minute'
    mmhg: 'mmhg'
    mmolPerL: 'mmolPerL'
    percent: 'percent'
    pound: 'pound'
    kilogram: 'kg'
    second: 'second'
  }

  export type HealthPermission = {
    ActiveEnergyBurned: 'ActiveEnergyBurned'
    AppleExerciseTime: 'AppleExerciseTime'
    BasalEnergyBurned: 'BasalEnergyBurned'
    BiologicalSex: 'BiologicalSex'
    BloodGlucose: 'BloodGlucose'
    BloodPressureDiastolic: 'BloodPressureDiastolic'
    BloodPressureSystolic: 'BloodPressureSystolic'
    BodyFatPercentage: 'BodyFatPercentage'
    BodyMass: 'BodyMass'
    BodyMassIndex: 'BodyMassIndex'
    BodyTemperature: 'BodyTemperature'
    DateOfBirth: 'DateOfBirth'
    Biotin: 'Biotin'
    Caffeine: 'Caffeine'
    Calcium: 'Calcium'
    Carbohydrates: 'Carbohydrates'
    Chloride: 'Chloride'
    Cholesterol: 'Cholesterol'
    Copper: 'Copper'
    EnergyConsumed: 'EnergyConsumed'
    FatMonounsaturated: 'FatMonounsaturated'
    FatPolyunsaturated: 'FatPolyunsaturated'
    FatSaturated: 'FatSaturated'
    FatTotal: 'FatTotal'
    Fiber: 'Fiber'
    Folate: 'Folate'
    Iodine: 'Iodine'
    Iron: 'Iron'
    Magnesium: 'Magnesium'
    Manganese: 'Manganese'
    Molybdenum: 'Molybdenum'
    Niacin: 'Niacin'
    PantothenicAcid: 'PantothenicAcid'
    Phosphorus: 'Phosphorus'
    Potassium: 'Potassium'
    Protein: 'Protein'
    Riboflavin: 'Riboflavin'
    Selenium: 'Selenium'
    Sodium: 'Sodium'
    Sugar: 'Sugar'
    Thiamin: 'Thiamin'
    VitaminA: 'VitaminA'
    VitaminB12: 'VitaminB12'
    VitaminB6: 'VitaminB6'
    VitaminC: 'VitaminC'
    VitaminD: 'VitaminD'
    VitaminE: 'VitaminE'
    VitaminK: 'VitaminK'
    Zinc: 'Zinc'
    Water: 'Water'
    DistanceCycling: 'DistanceCycling'
    DistanceWalkingRunning: 'DistanceWalkingRunning'
    FlightsClimbed: 'FlightsClimbed'
    HeartRate: 'HeartRate'
    Height: 'Height'
    LeanBodyMass: 'LeanBodyMass'
    MindfulSession: 'MindfulSession'
    NikeFuel: 'NikeFuel'
    RespiratoryRate: 'RespiratoryRate'
    SleepAnalysis: 'SleepAnalysis'
    StepCount: 'StepCount'
    Steps: 'Steps'
    Weight: 'Weight'
  }

  const appleHealthKit: AppleHealthKit
  export default appleHealthKit

  export const HealthKitPermissions: {
    [key in keyof HealthPermission]: HealthPermission
  }
  export const HealthKitUnits: { [key in keyof HealthUnit]: HealthUnit }
}
