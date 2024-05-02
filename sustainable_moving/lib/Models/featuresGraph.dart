import 'package:draw_graph/models/feature.dart';
import 'package:flutter/material.dart';

/* Tipo feauture, l'ho messo qui, però prima nel main funzionava, l'ho fatto per
 * ordianare il codice, non sono riuscito a collegarlo. */

/* TODO Collega il codice a Feature affinché mostri il grafico con BPM i dati 
 * prelevati con la get di HEART RATE ( getHeartRate() ha pulses = heartRate) */

final List<Feature> features = [
  Feature(
    title: "BPM",
    color: Colors.red,
    data: [],
  ),
  Feature(
    title: "Water",
    color: Colors.blue,
    data: [1, 0.8, 0.6, 0.7, 0.3],
  ),
];
