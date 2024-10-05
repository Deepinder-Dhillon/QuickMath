
# QuickMath
![QM_icon (1) (1)](https://github.com/user-attachments/assets/798c107c-fe25-48af-9abc-18f8f355b634)

**QuickMath** is a simple SwiftUI math game that generates a variety of basic math problems for users to solve. The app dynamically categorizes these problems into five different difficulty levels, using a CoreML model to predict the difficulty of each generated problem. The app offers a progressively challenging experience, allowing users to improve their math skills at their own pace.

## Table of Contents
- [Demo](#demo)
- [Screenshots](#screenshots)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Contributing](#Contributing)
- [License](#License)

## Demo

<div align="center">


</div>

## Screenshots

<div align="center">
  <!-- Row 1 -->
</div>

## Features

- **Math Problem Generation**: A method is used to generate simple math problems (addition, subtraction, multiplication, division). The app pre-generates these problems and stores them in five arrays corresponding to different difficulty levels.
- **CoreML-Based Difficulty Prediction**: The app leverages a CoreML model to predict the difficulty of each problem based on its structure and content. Problems are categorized into five difficulty levels using this model.
- **Score Progression**: As users solve problems and their score increases, the game pulls more challenging problems from higher difficulty arrays.
- **Custom Problem Sets**: Problems are generated once and stored in arrays, with difficulty managed by the CoreML predictor rather than adjusting in real-time.

## Training Dataset and CoreML Model

The CoreML model used to predict difficulty was trained with a dataset of math problems with varying complexity. The model uses the **random forest** algorithm and achieved a **validation accuracy of 0.39**. This allows for reasonably accurate difficulty classification for the generated problems, which are then categorized into five levels.

## Technologies Used

- **SwiftUI**: For building the user interface and providing a smooth user experience.
- **CoreML**: To predict and categorize the difficulty of math problems using a random forest model.
- **JSON Encoding/Decoding**: For storing generated math problems based on difficulty level.
  

## Contributing
Contributions are welcome! Whether you have ideas for improving the game mechanics, enhancing the difficulty prediction model, or introducing new problem types, feel free to fork the repository, make changes, and submit a pull request.

## License
This project is licensed under the MIT License, allowing you to modify, distribute, and use the code with proper attribution to the original creators.
