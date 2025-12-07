# COP4655 Original App Design Project
# The Spice of Life
## Table of Contents
1. Overview
2. Product Specifications
3. Wireframes
4. Schema


# Overview
## Description
My app, A Spice for Life, is a recipe/cookbook app. Users create an account and can search, find, and download the best recipes from across the world. They can test out new styles and blends, review others' books, and cultivate a new appreciation for cultural or individual meals. The best way to a person's heart is through their stomach, after all!

## App Evaluation
- **Category:** Social/Education. Primarily a place to share recipes (Education), but I plan to add functionality to review recipes (Social).
- **Mobile:** Will be only a mobile app. May add a website or desktop version in the future, but for now the focus will firmly be mobile.
- **Story:** My app will tell a story about culture, since each culture features different cuisine and styles of cooking. Acceptance allows for more variety of food.
- **Market:** My app will primarily focus on peope interested in the culinary arts, alongside novices and people just trying to make a good meal. It'll, ideally, appeal to a wide audiance because of how ubiquitous food is. With the small social aspect of reviewing recipes, it may also bring in people interested in becoming critics. 
- **Habit:** How often the app is used depends on how often the user is trying new dishes. For people who like to experiment it may be daily or close to it, while others may use it only when it strikes their fancy or they splurge for more ingredients to cook with.
- **Scope:** I'd like for my app to be a bit balanced on the feature department. Some features should be explored more in depth, like the downloading recipes aspect, while other features could be left surface-level.

# Product Specifications
## User Stories
- [X] Users can create an account
- [X] Users can browse recipes (either trending, random, new, etc)
- [X] Users can search for specific recipes
- [X] Users can read recipe details
- [X] Users can potentially interact with the recipes, such as if they feature an embedded video.
- [X] Users can download recipes
- [X] Users can look at downloaded recipes locally when not connected to the internet.
- [X] Users can look at reviews of recipes from other users
- [X] Users can make their own review of recipes

## App Demonstration:
[![App Demo](https://img.youtube.com/vi/UHccOnAZAqo/0.jpg)](https://www.youtube.com/watch?v=UHccOnAZAqo "App Demo")

## Screen Archetypes

**Login Screen**

- Where users can login to the app or sign up

**Recipe Feed Screen**

- Where users can go to browse for recipes.

**Recipe Detail Screen**

- Where users can go to look more closely at recipes and learn more about them. A button will lead to a feed for reviews of the recipe.

**Downloaded Recipes Feed Screen**

- Users can go here to see their locally downloaded recipes.

**Recipe Review Screen**

- Users come here from the Recipe Detail Screen and see reviews from other users. This also leads to the Review Creation Screen.

**Review Creation Screen**

- Users can go here to create a review for a recipe.


## Navigation
**Tab Navigation** (Tab to Screen)
- The first screen the user is greeted with is the login screen.
- The second screen the user can tab to is the Feed, which can also be accessed via screen-to-screen from the login screen.
- The third screen tab is the download section, where users can see their downloaded recipes.

**Flow Navigation** (Screen to Screen)
- Login Screen
  - Leads to Feed Screen
- Feed Screen
  - Leads to Recipe Detail Screen
- Downloaded Recipes Feed Screen
  - Leads to Recipe Detail Screen
- Recipe Detail Screen
  - Leads to Review Feed Screen
- Review Feed Screen
  - Leads to Review Creation Screen

# Wireframes
## Digital Wireframes via Figma:
<img width="1988" height="1358" alt="image" src="https://github.com/user-attachments/assets/242905b2-f56e-4104-b529-3902c8a27a70" />

<img width="2080" height="1516" alt="image" src="https://github.com/user-attachments/assets/d598769f-4ef3-49ac-ae28-56428d4363f7" />

<img width="2082" height="1516" alt="image" src="https://github.com/user-attachments/assets/4c1949b3-a718-4e22-baed-f742c6d70270" />

<img width="2094" height="1516" alt="image" src="https://github.com/user-attachments/assets/6efceeb1-f4d0-4afc-8b85-514fda8c5fc7" />

<img width="2100" height="1516" alt="image" src="https://github.com/user-attachments/assets/6f36ff33-6461-4b73-926d-766655290121" />

<img width="2104" height="1516" alt="image" src="https://github.com/user-attachments/assets/587b328d-2555-4d7f-b6cf-492677a3b270" />

<img width="2092" height="1516" alt="image" src="https://github.com/user-attachments/assets/1695c3c0-6f12-4948-866f-835f69e2fa4e" />

# Schema
## Models:
**Users**
| **Property** | **Type** | **Description** |
| :--- | :--- | :--- |
| Username | String | The name Users can give themselves. Will show up in the top right of the Feed screen and in reviews |
| Password | String | Using Firebase for user authentication, so this will stored and authenticated from there |
| User_ID | String | An ID unique to each user |

**Recipe**
| **Property** | **Type** | **Description** |
| :--- | :--- | :--- |
| ID | String | ID unique for each recipe |
| Title | String | Title for the recipe; usually the food being made, such as Chicken Tikka Masala |
| Image_URL | String | URL for an image of the finished product |
| Ingredients | Array | An array/list of the needed ingredients |
| Instructions | String | Instructions on how to make the food |
| Is_Downloaded | Bool | See if it's already been downloaded or not|

**Review**
| **Property** | **Type** | **Description** |
| :--- | :--- | :--- |
| Review_ID | String | Unique ID for each review |
| user_ID | String | The ID of the user who made the review |
| Star_Count | Int | A number from 1 to 5 for how much a user liked the recipe |
| Review_Text | String | The actual review in text |
| Date_Posted | Date | The date for when the review was posted |

## Networking
* **Login Screen**:
  * POST (send) user data and authenticate with the provided email/password
* **Recipe Feed**
  * GET the API data to display the recipes
* **Recipe Detail Screen**
  * GET the API data to see a more detailed look at the the recipes.
* **Downloaded Recipe Feed Screen**
  * GET from local data on downloaded recipes
* **Recipe Review Screen**
  * GET from firebase for reviews associated with the recipe's ID
* **Review Creation Screen**
  * POST the review into firebase
