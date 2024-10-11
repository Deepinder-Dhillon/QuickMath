
# QuickMath
![QM_icon (1) (1)](https://github.com/user-attachments/assets/798c107c-fe25-48af-9abc-18f8f355b634)

**QuickMath** It’s a simple game with basic math problems where the difficulty increases as your score goes up, making it more challenging. The app uses CoreML to generate random problems with difficulty levels ranging from 1 to 5 and sorts them into pre-scored categories. It’s a fun way to test your metal math skills.
## Table of Contents
- [Demo](#demo)
- [Screenshots](#screenshots)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Contributing](#Contributing)
- [License](#License)

## Demo


<div align="center">


https://github.com/user-attachments/assets/a6569fca-026f-475b-9eee-f34c1c3a00e9


</div>

## Screenshots

<div align="center">
  <!-- Row 1 -->
  <img src="https://github.com/user-attachments/assets/993edeee-5b54-4fd7-9a1a-5bd038420ee6" alt="iPhone 16 Pro - Natural Titanium 12" width="20%">
  <img src="https://github.com/user-attachments/assets/755ca2f8-3b2c-43a9-90c2-7688290a0c6c" alt="iPhone 16 Pro - Natural Titanium 10" width="20%">
  

 
  <img src="https://github.com/user-attachments/assets/8643b588-3a33-4e1c-9b10-011bec6ad1d8" alt="iPhone 16 Pro - Natural Titanium 9" width="20%">
  <img src="https://github.com/user-attachments/assets/317019e1-500f-4af9-9102-c1d68d25296f" alt="iPhone 16 Pro - Natural Titanium 11" width="20%">
</div>


## Features
- **Problem Generation**: Separate method that generates basic math problems and uses a CoreML model to predict their difficulty. Based on the predicted difficulty, the problems are stored in five different levels.
- **Progressive Difficulty**: As players solve problems and increase their score, the app delivers more challenging problems from higher difficulty levels, ensuring an engaging, evolving challenge.
- **Dynamic Timer**: The game has a timer that increases when you answer correctly, giving you more time to play. If you get an answer wrong, time is deducted, making it more challenging to keep going. This adds a fun and exciting twist to the game!
## Technologies Used

- **SwiftUI**: For building the user interface and providing a smooth user experience.
- **CoreML**: To predict and categorize the difficulty of math problems using a random forest model.
- **JSON Encoding/Decoding**: For storing generated math problems based on difficulty level.
  

## Contributing
Contributions are welcome! Whether you have ideas for improving the game mechanics, enhancing the difficulty prediction model, or introducing new problem types, feel free to fork the repository, make changes, and submit a pull request.

## License
This project is licensed under the MIT License, allowing you to modify, distribute, and use the code with proper attribution to the original creators.
