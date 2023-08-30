export function calculateDistance(coord1, coord2) {
    const R = 6371;
    const PI = Math.PI;

    const lat1Rad = (coord1.Location__Latitude__s * PI) / 180;
    const lon1Rad = (coord1.Location__Longitude__s * PI) / 180;
    const lat2Rad = (coord2.BillingLatitude * PI) / 180;
    const lon2Rad = (coord2.BillingLongitude * PI) / 180;

    const dLat = lat2Rad - lat1Rad;
    const dLon = lon2Rad - lon1Rad;

    const a =
        Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(lat1Rad) * Math.cos(lat2Rad) * Math.sin(dLon / 2) * Math.sin(dLon / 2);

    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    return R * c;
}

export function sortByDistance(coordinates, mainLocation) {
    coordinates.sort((a, b) => {
        const distanceA = calculateDistance(a, mainLocation);
        const distanceB = calculateDistance(b, mainLocation);

        return distanceA - distanceB;
    });

    return coordinates;
}