# Rhythm Game Intervention for Visually Impaired Children: Enhancing Therapy Using an Interactive Room”


## Overview
Visually impaired children often face unique challenges with traditional therapeutic interventions, which can lead to disengagement and reduced effectiveness due to their repetitive and monotonous nature. This thesis presents
the creation of an innovative rhythm game designed to enhance therapy for
visually impaired children by utilizing Processing and Kinect SDK within an
interactive room setting. The game aims to provide a multi-sensory, engaging, and dynamic experience that encourages children to actively participate
in their therapy sessions.
The interactive rhythm game employs the Kinect sensor to capture the
children’s movements, converting physical actions into game interactions.
This method not only makes therapy sessions more enjoyable but also aids
in the development of motor skills, spatial awareness, and cognitive abilities. The game includes sound cues and accessible visual elements to ensure
engagement for children with varying degrees of visual impairment.
This thesis explores the background and motivation for using interactive
rooms in therapy, detailing the benefits and technological advancements
that enable these innovative therapeutic tools. It also provides an in-depth
overview of the game’s design and development process, including the reasoning behind key design choices, the implementation of technology, and the
data logging and performance tracking methods used.
The aim of this study is to conduct evaluation using Heuristic Evaluation as, testing with vulnerable minors was not possible. This evaluation
approach is applied to a case game. The heuristic evaluation method successfully generates a list of practical suggestions for further development.
This method allows for the evaluation of similar games without directly
involving the intended audience.
This project demonstrates the potential of using advanced interactive
technologies to complement traditional therapy methods, making them more
effective and enjoyable for visually impaired children.

## Features

- **Audio Feedback**: Provides immediate and recognizable audio feedback when nodes are touched.
- **Adjustable Node Speed**: Allows users to increase or decrease the speed of falling nodes.
- **Pause and Resume**: The game can be paused and resumed at any time.
- **Help Section**: A help button on the dashboard provides instructions for playing the game.
- **Win Condition**: The player wins the game by scoring 10 points.

## Installation

1. **Clone the repository**:
    ```sh
    git clone https://github.com/arunkumarsanku/GuitarGame.git
    cd GuitarGame
    ```

2. **Install Processing**:
    Download and install [Processing](https://processing.org/download/).

3. **Install Libraries**:
    - **ControlP5**:
      - Open Processing.
      - Go to `Sketch` > `Import Library` > `Add Library`.
      - Search for `ControlP5` and install it.
    - **Minim**:
      - Similarly, search for `Minim` and install it.

4. **Add Data Files**:
    - Place the sound files (`1.wav`, `2.wav`, etc.) and images (`guitar_background.jpg`, `Congratulations.jpg`) in the `data` folder of your Processing sketch.

## Usage

1. **Open the Project**:
    - Open Processing.
    - Open the `guitar_thesis` file.

2. **Run the Project**:
    - Click the run button in Processing to start the game.

3. **Game Instructions**:
    - Click the `Start` button to begin the game.
    - Use the mouse to move the tracker and touch the falling nodes to score points.
    - Adjust the node speed using the `Speed +1` and `Speed -1` buttons.
    - Click the `Pause` button to pause the game and `Resume` to continue.
    - Click the `Help` button to view game instructions.
    - Reach a score of 10 to win the game.

## Code Structure

- **`Game` Class**: Manages the game logic, including node management, collision detection, and sound playback.
- **`Dashboard` Class**: Handles the UI elements for controlling the game, such as start, pause, speed adjustment, and help instructions.
- **`Node` Class**: Represents the individual nodes in the game.
- **Main Sketch**: Initializes and runs the game and UI components.
```
# Screenshots of Game

## Dashboard
![Dashboard](Dashboard.png)

## Gameplay
![Gameplay](Gameplay.png)

## Gameplay
![Gameplay](Gameplay1.png)

## Gameplay
![Gameplay](Gameplay2.png)

## Win Screen
![Win Screen](Win.png)
```
