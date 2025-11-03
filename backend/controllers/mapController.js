const getOptimizedRoute = async (req, res) => {
    const { originLat, originLng, destinationQuery } = req.body;

    
    console.log(`Petición de ruta desde (${originLat}, ${originLng}) hacia "${destinationQuery}"`);

   
    const mockRoute = {
        routePoints: [
            { latitude: originLat, longitude: originLng },
            { latitude: originLat + 0.005, longitude: originLng + 0.005 },
            { latitude: originLat + 0.006, longitude: originLng + 0.010 },
            { latitude: 3.3744, longitude: -76.5332 }, // Coordenadas de ejemplo cerca de la USC
        ],
        estimatedTime: '15 minutos',
        estimatedCost: '$8.000 COP'
    };

    res.json(mockRoute);
};

module.exports = { getOptimizedRoute };
