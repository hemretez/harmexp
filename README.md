# harmexp

This project is implemented in Processing. (It can be easily ported to Javascript.)

The areas such as physics, music visualization, 2D displays and force-feedback have great potentials for discovering new musical interaction ways. The interface has inherent music knowledge (expert agents) which is integrated in order to give intuition about tonal movements via the objects on 2D space. The action of these objects are designed in the light of these diverse areas. 

The system is designed to use the probabilistic models of music such as chord transition probabilities, because the chords are one of the higher order musical concepts and they are the tonal frameworks of the music pieces. These probabilistic models are fruitful in terms of being models of different genres or specific artists. Moreover, there is no absolute focus on the chords, but the musical concepts which are tied (or represented) by probabilities. Another instance can be the melodic phrases or sections of a song. Using chords to explore that domain and realize ideas in this system is one the affordances.

The end system has underlying harmony knowledge (expert agent) which originates from those models. The interface never shows the most probable next state or warn the user, when a “wrong” progression is performed. However, it is designed to make the user “feel” the tensions between represented musical concepts.

For extracting the transition probability tables from McGill Billboard collection, Python was used. In McGill Billboard collection, there is a log file which includes the chord type, its exact time to start and end for each individual

To produce sound, Pure Data is used. A PD patch receives OSC signals which consist chord data. In PD, OSC signals are converted to MIDI and sent to a DAW to produce high quality instrument sounds with VST instruments.
