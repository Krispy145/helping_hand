"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
require("dotenv/config");
const client_1 = require("@prisma/client");
const bcrypt = __importStar(require("bcrypt"));
const prisma = new client_1.PrismaClient();
const SEED_EMAIL_DOMAIN = 'helpinghand.seed';
const SEED_PASSWORD = 'password123';
const USER_COUNT = 200;
const REQUEST_COUNT = 500;
const GEO_BIN_KM = 1.2;
const CITIES = [
    { name: 'Johannesburg', lat: -26.2041, lng: 28.0473, radiusKm: 8, weight: 0.4 },
    { name: 'Cape Town', lat: -33.9249, lng: 18.4241, radiusKm: 8, weight: 0.4 },
    { name: 'Plettenberg Bay', lat: -34.0527, lng: 23.3716, radiusKm: 5, weight: 0.2 },
];
const DISPLAY_NAMES = [
    'Amara', 'Thabo', 'Lerato', 'Sipho', 'Naledi', 'Ayesha', 'Zanele', 'Karabo',
    'Palesa', 'Mandla', 'Nomsa', 'Kabelo', 'Andile', 'Tshepo', 'Sibusiso',
    'Cedar', 'River', 'Indigo', 'Moss', 'Harbor', 'Quill', 'Marigold', 'Pebble',
];
const REQUEST_TEMPLATES = [
    { title: 'Need a grocery run this afternoon', description: 'Could use a hand picking up a few essentials from a nearby shop. Happy to meet in a public place.', category: 'groceries' },
    { title: 'Help carrying boxes upstairs', description: 'A few light boxes to move up one flight of stairs. Should take about 20 minutes.', category: 'moving' },
    { title: 'Walk a dog this evening', description: 'Looking for someone nearby to take a short neighbourhood walk with a friendly dog.', category: 'pet-care' },
    { title: 'Phone setup help', description: 'Need someone patient to help set up a new phone and explain the basics in a public cafe.', category: 'tech-help' },
    { title: 'Company for a walk to the clinic', description: 'Would appreciate a friendly person to walk with me to a nearby clinic and back.', category: 'companionship' },
    { title: 'Need a lift to the library', description: 'Looking for a short ride to the public library this weekend.', category: 'transport' },
    { title: 'Help reading a municipal letter', description: 'I received a letter I am struggling to understand. Would like someone to go through it with me in a public place.', category: 'language' },
    { title: 'Tutor a teen in maths', description: 'Looking for an hour of high-school maths help this week, in a public cafe.', category: 'tutoring' },
    { title: 'Collect a parcel nearby', description: 'Cannot get to the collection point today. Details can stay in-app.', category: 'errands' },
    { title: 'Help hanging two shelves', description: 'Need an extra pair of hands and a spirit level for about 30 minutes.', category: 'household' },
    { title: 'Translate a short form', description: 'Need help filling in a short form at a public office.', category: 'language' },
    { title: 'Someone to sit with at the park', description: 'Would like company for a short sit in a public park.', category: 'companionship' },
    { title: 'Help choosing a bus route', description: 'New in the area and need help figuring out a public-transport route.', category: 'transport' },
    { title: 'Pick up a prescription nearby', description: 'Unable to get to the pharmacy before it closes. Can share details in chat.', category: 'errands' },
    { title: 'Show me email on a tablet', description: 'Need a calm walkthrough of sending and reading email on a tablet.', category: 'tech-help' },
];
function pick(items) {
    return items[Math.floor(Math.random() * items.length)];
}
function weightedCity() {
    const roll = Math.random();
    let cumulative = 0;
    for (const city of CITIES) {
        cumulative += city.weight;
        if (roll <= cumulative)
            return city;
    }
    return CITIES[0];
}
function offsetAround(city) {
    const distanceKm = city.radiusKm * Math.sqrt(Math.random());
    const bearing = Math.random() * Math.PI * 2;
    const latOffset = (distanceKm * Math.cos(bearing)) / 111;
    const lngOffset = (distanceKm * Math.sin(bearing)) / (111 * Math.cos((city.lat * Math.PI) / 180));
    return snapToApproxBin(city.lat + latOffset, city.lng + lngOffset);
}
function snapToApproxBin(lat, lng) {
    const latBin = GEO_BIN_KM / 111;
    const lngBin = GEO_BIN_KM / (111 * Math.cos((lat * Math.PI) / 180));
    return {
        lat: Math.round(lat / latBin) * latBin,
        lng: Math.round(lng / lngBin) * lngBin,
    };
}
function pickStatus() {
    const roll = Math.random();
    if (roll < 0.82)
        return client_1.RequestStatus.APPROVED;
    if (roll < 0.9)
        return client_1.RequestStatus.PENDING_VETTING;
    if (roll < 0.95)
        return client_1.RequestStatus.IN_PROGRESS;
    if (roll < 0.98)
        return client_1.RequestStatus.COMPLETED;
    return client_1.RequestStatus.REJECTED;
}
function pickUrgency() {
    const roll = Math.random();
    if (roll < 0.2)
        return client_1.RequestUrgency.LOW;
    if (roll < 0.7)
        return client_1.RequestUrgency.MEDIUM;
    if (roll < 0.93)
        return client_1.RequestUrgency.HIGH;
    return client_1.RequestUrgency.CRITICAL;
}
function displayName(index) {
    const token = (index + 17).toString(16).slice(-2);
    return `${pick(DISPLAY_NAMES)} · ${token}`;
}
function seedEmail(index) {
    return `u${String(index).padStart(3, '0')}@${SEED_EMAIL_DOMAIN}`;
}
async function main() {
    console.log('Seeding anonymous Helping Hand dev data...');
    await prisma.message.deleteMany({
        where: { sender: { email: { endsWith: `@${SEED_EMAIL_DOMAIN}` } } },
    });
    await prisma.session.deleteMany({
        where: { helper: { email: { endsWith: `@${SEED_EMAIL_DOMAIN}` } } },
    });
    await prisma.request.deleteMany({
        where: { user: { email: { endsWith: `@${SEED_EMAIL_DOMAIN}` } } },
    });
    await prisma.user.deleteMany({
        where: { email: { endsWith: `@${SEED_EMAIL_DOMAIN}` } },
    });
    const password = await bcrypt.hash(SEED_PASSWORD, 10);
    await prisma.user.createMany({
        data: Array.from({ length: USER_COUNT }, (_, index) => ({
            email: seedEmail(index + 1),
            password,
            name: displayName(index + 1),
            role: client_1.Role.USER,
        })),
    });
    const users = await prisma.user.findMany({
        where: { email: { endsWith: `@${SEED_EMAIL_DOMAIN}` } },
        select: { id: true },
    });
    const cityCounts = new Map(CITIES.map((city) => [city.name, 0]));
    await prisma.request.createMany({
        data: Array.from({ length: REQUEST_COUNT }, () => {
            const city = weightedCity();
            cityCounts.set(city.name, (cityCounts.get(city.name) ?? 0) + 1);
            const location = offsetAround(city);
            const template = pick(REQUEST_TEMPLATES);
            return {
                title: template.title,
                description: template.description,
                category: template.category,
                status: pickStatus(),
                urgency: pickUrgency(),
                lat: location.lat,
                lng: location.lng,
                userId: pick(users).id,
            };
        }),
    });
    const approved = await prisma.request.count({
        where: {
            user: { email: { endsWith: `@${SEED_EMAIL_DOMAIN}` } },
            status: client_1.RequestStatus.APPROVED,
        },
    });
    console.log(`Created ${USER_COUNT} users with display names only (login: ${SEED_PASSWORD})`);
    console.log(`Created ${REQUEST_COUNT} requests (${approved} approved), snapped to ~${GEO_BIN_KM}km bins`);
    for (const [city, count] of cityCounts) {
        console.log(`  ${city}: ${count} requests`);
    }
}
main()
    .catch((error) => {
    console.error(error);
    process.exit(1);
})
    .finally(async () => {
    await prisma.$disconnect();
});
//# sourceMappingURL=seed.js.map