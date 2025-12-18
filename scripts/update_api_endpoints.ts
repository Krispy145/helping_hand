
import * as fs from 'fs';
import * as path from 'path';
import axios from 'axios';

const OUTPUT_FILE = path.join(__dirname, '../packages/utils/lib/src/constants/api_endpoints.dart');
const OPENAPI_URL = 'http://localhost:3000/api-json'; // Adjust if your valid URL is different

async function fetchOpenApiSpec() {
  try {
    const response = await axios.get(OPENAPI_URL);
    return response.data;
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    console.error('Error fetching OpenAPI spec:', message);
    process.exit(1);
  }
}

function generateDartCode(paths: any): string {
  let code = `class ApiEndpoints {\n`;
  const usedNames = new Set<string>();

  for (const [routePath, methods] of Object.entries(paths)) {
    // Determine method name from path
    // e.g. /auth/login -> authLogin
    // e.g. /requests/{id} -> requestDetails
    
    // Simple heuristic: 
    // 1. Remove leading slash
    // 2. Split by slash
    // 3. Convert to camelCase
    
    // Check if path has parameters (e.g. {id})
    const isParameterized = routePath.includes('{');
    
    let nameParts = routePath.split('/').filter(p => p.length > 0);
    let varName = nameParts.map((p, i) => {
      if (p.startsWith('{')) return ''; // Skip params in name generation for now
      if (i === 0) return p;
      return p.charAt(0).toUpperCase() + p.slice(1);
    }).join('');

    // Override generic names if needed or handle duplicates
    if (varName === '') varName = 'root';
    
    if (usedNames.has(varName)) {
      varName = varName + '2'; // basic collision handling
    }
    usedNames.add(varName);

    if (isParameterized) {
       // Generate a method: static String sessionMessages(String id) => '/sessions/$id/messages';
       // Extract params: /sessions/{id}/messages -> ['id']
       const params = (routePath.match(/\{([^}]+)\}/g) || []).map(p => p.slice(1, -1));
       const dartParams = params.map(p => `String ${p}`).join(', ');
       // Use callback for more predictable replacement
       const dartPath = routePath.replace(/\{([^}]+)\}/g, (_, p1) => `\$${p1}`);
       
       code += `  static String ${varName}(${dartParams}) => '${dartPath}';\n`;
    } else {
       // Generate a const: static const String login = '/auth/login';
       code += `  static const String ${varName} = '${routePath}';\n`;
    }
  }

  // Manual additions
  code += `  static const String chatSocket = '/chat';\n`;

  code += `}\n`;
  return code;
}

async function main() {
  console.log('Fetching OpenAPI spec...');
  const spec = await fetchOpenApiSpec();
  
  if (!spec.paths) {
    console.error('No paths found in OpenAPI spec.');
    process.exit(1);
  }

  console.log(`Found ${Object.keys(spec.paths).length} paths. Generating Dart code...`);
  const dartCode = generateDartCode(spec.paths);
  
  fs.writeFileSync(OUTPUT_FILE, dartCode);
  console.log(`Successfully wrote to ${OUTPUT_FILE}`);
}

main();
