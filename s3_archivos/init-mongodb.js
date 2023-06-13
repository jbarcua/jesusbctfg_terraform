db.createUser(
    {
        user: "admin",
        pwd: "example",
        roles: [
            {
                role: "readWrite",
                db: "test"
            }
        ]
    }
);

db = new Mongo().getDB("test");
db.createCollection('layers', { capped: false });

db.layers.insert({
    "_id" : ObjectId("611d1ad5dfb24e64eb994bce"),
    "owner" : "pepe",
    "catastralReference" : "10022A010000380000WZ",
    "geoData" : {
        "type" : "FeatureCollection",
        "features" : [
            {
                "type" : "Feature",
                "geometry" : {
                    "type" : "Polygon",
                    "coordinates" : [
                        [
                            [
                                -6.611499,
                                39.479508
                            ],
                            [
                                -6.611499,
                                39.479508
                            ],
                            [
                                -6.611484,
                                39.479505
                            ],
                            [
                                -6.611397,
                                39.479506
                            ],
                            [
                                -6.611327,
                                39.47952
                            ],
                            [
                                -6.611263,
                                39.479538
                            ],
                            [
                                -6.6112,
                                39.479557
                            ],
                            [
                                -6.611136,
                                39.479562
                            ],
                            [
                                -6.611083,
                                39.479553
                            ],
                            [
                                -6.611013,
                                39.479527
                            ],
                            [
                                -6.610954,
                                39.479473
                            ],
                            [
                                -6.610813,
                                39.479339
                            ],
                            [
                                -6.610701,
                                39.479254
                            ],
                            [
                                -6.610619,
                                39.479187
                            ],
                            [
                                -6.610594,
                                39.479149
                            ],
                            [
                                -6.61144,
                                39.478937
                            ],
                            [
                                -6.611493,
                                39.479257
                            ]
                        ]
                    ]
                },
                "properties" : {}
            }
        ]
    },
    "_class" : "com.tfm.microservices.plots.repository.Plot"
});
