#!/bin/bash

mongo <<EOF
const joker = {
    user: "joker",
    pwd: "joker",
    roles: [
        { role: "readWrite", db: "comedy" },
    ]
};
const root = {
    user: "root",
    pwd: "root",
    roles: [
        { role: "root", db: "admin" },
    ]
};
const exporter = {
    user: "mongo_exporter",
    pwd: "mongo_exporter",
    roles: [
        { role: "clusterMonitor", db: "admin" },
    ]
};

db = connect("mongodb://localhost/comedy");
db.movieExps.insertMany([
    {
       title: 'Titanic',
       year: 1997,
       genres: ['Drama', 'Romance']
    },
    {
       title: 'Spirited Away',
       year: 2001,
       genres: ['Animation', 'Adventure', 'Family']
    },
    {
       title: 'Casablanca',
       genres: ['Drama', 'Romance', 'War']
    }
]);

use comedy;
Array.of(root, joker, exporter).forEach((e) => {
    let isExist = db.getUser(e.user) ? true : false;
    if (!isExist) db.createUser(e);
});
db.createCollection("comedy");
db.runCommand({ create: "comedy" });
EOF
