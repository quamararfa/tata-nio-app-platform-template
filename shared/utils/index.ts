import { Construct } from "constructs";
import { MethodLoggingLevel } from 'aws-cdk-lib/aws-apigateway';


// Write function to convert snakecase to camelCase
export function toCamelCase(str: string) {
    return str.replace(/_([a-z])/g, (g) => g[1].toUpperCase());
}

// Write function to convert snakecase to PascalCase
export function toPascalCase(str: string) {
    str = toCamelCase(str);
    return str.charAt(0).toUpperCase() + str.slice(1);
}

// Write function to generate resource name based on prefix
export const getPrefix = (use_case: string, environment: string, region: string ) => {
    return `${use_case}-${environment}-${region.split("-").join("")}`;
}

/**
 * Looks up default value from context (cdk.json, cdk.context.json and ~/.cdk.json)
 */
export function valueFromContext(construct: Construct, key: string, defaultValue: string) {
    return construct.node.tryGetContext(key) ?? defaultValue;
}

export function getLoggingLevelMap(): Map<string, MethodLoggingLevel> {
  return new Map<string, MethodLoggingLevel>([
    ['ERROR', MethodLoggingLevel.ERROR],
    ['INFO', MethodLoggingLevel.INFO],
    ['OFF', MethodLoggingLevel.OFF],
  ]);
}