# Cassava Leaf Disease Classification
Using Machine Learning Algorithms to Identify the Type of Disease Present on a Cassava Plant Image



## Abstract

Cassava plants are a key food security crop grown by local farmers in Africa due to the plant's ability to withstand harsh outdoor elements. When Cassava plants incur disease, it can devastate a local farmer's crops and income that drastically affects their source of food and quality of life. As a data scientist, I have been tasked with helping to identify 4 different types of viral diseases from healthy plants on plant images in an attempt to expedite disease identification and mitigate local African farmer's poor crop yields.

In this project, I have ~21k images of Cassava plants that I will use to train a disease classification model using a convultional neural network (CNN) with an accuracy score higher than baseline accuracy of ~61%. By applying transfer learning using EfficientNetB architecture and callbacks for early stopping & learning rate reduction, I yield a validation accuracy of ~86% and validation loss of ~44% to detect the 5 different classes of plants.

For future work, I would like to enhance this CNN by applying Test Time Augmentation. I would like to see how well the model performs on larger image files, increasing the resolution up to 448x448x3. I would like to explore other transfer learning architectures that might further improve the baseline chosen in this project. And lastly, I would like to try to oversample classes to adjust for imbalanced data presented.


## Overview and Background

Cassava plants are a key food security crop grown by local farmers in Africa due to the plant's ability to withstand harsh outdoor elements. As one of the biggest providers of carbohydrates in Africa after rice and maize and at least 80% of household farms in Sub-Saharan Africa grow this starchy root, I (as a data scientist) have been tasked with building a model that can identify viral diseases on the plants as this is a major reason of poor crop yields.

As it stands today, these diseases are transmitted by the whitefly <i>Bemisia tabaci</i> and can quickly dessimate an entire crop's bounty. If farmers require help to detect disease within their crops, they must go through an arduous task of soliciting the help of government-funded agricultural experts, leading to delays in assessing crop damage and risk of destroying their entire crop base due to the spread of disease. As an added challenge, any image detection solution must perform well under low quality images, since African farmers may only have access to mobile-quality cameras with low-bandwidth.

I am tasked to classify each Cassava plant image into four disease categories or a fifth category indicating a healthy plant. With my help, farmers may be able to quickly identify diseased plants, potentially saving their crops before they inflict irreparable damage.

In this project, we will train a convultional neural network (CNN) that must have an accuracy score higher than the baseline accuracy of ~61%. I demonstrate that by utilizing transfer learning, applying an EfficientNetB4 architecture and callbacks for early stopping and learning rate reduction, I yield an average validation accuracy score of ~86% & average validation loss of ~44% in our model.

## Goals

This repo is part of the work completed within UMBC's DATA602 Course: Intro to Data Analysis and Machine Learning.

In this project, I attempt to achieve the following:
<ol>
<li><b>Exploration of Cassava Disease Images:</b> Examine the images tagged to each Cassava Leaf Disease Type. </li>
<li><b>Image Preprocessing of Cassava Images: </b>Apply image preprocessing to augment the images in our dataset, as this will help us create a solid model. Additionally, will break out dataset into training & validation groups.</li>
<li><b>Train Convolutional Neural Network:</b> Applying transfer learning, using EfficientNetB architecture. </li>
<li><b>Loss & Accuracy Analysis on CNN:</b> Analysis of both training & validation loss and accuracy. </li>
<li><b>Recommendations and Future Work:</b> Provide initial conclusions on project and recommend future work to enhance the model. </li>
</ol>



## Data Details

<a href=https://www.kaggle.com/c/cassava-leaf-disease-classification>Kaggle Cassava Leaf Disease Detection Competition</a>

The dataset is part of an active competition as of December 2020; note the competition will end February 2021. The competition introduces a dataset of 21,367 labeled images collected during a regular survey in Uganda. Most images were crowdsourced from farmers taking photos of their gardens, and annotated by experts at the National Crops Resources Research Institute (NaCRRI) in collaboration with the AI lab at Makerere University, Kampala. The image format and documentation within the competition most realistically represents what farmers would need to diagnose in real life.

Each Cassava leaf image is identified as:
<ul>
<li>Cassava Bacterial Blight (CBB)</li>
<li>Cassava Brown Streak Disease (CBSD)</li> 
<li>Cassava Green Mottle (CGM)</li> 
<li>Cassava Mosaic Disease (CMD)</li>
</ul>


Since the dataset is too large to import into a Github repo, we will not be uploading every training image to this project (although I do provide an example of the images and the train.csv file as a reference). We will be referencing local copies of the files provided by Kaggle competition, including the following:

<ul>
<li><b>test_images:</b> A single sample image used to validate the model's prediction accuracy. Since this is an open competition, Kaggle has not provided us a full test image dataset, so we will use this single image to test the accuracy of our model.</li>
<li><b>train_images:</b> ~20k training images to help train the CNN</li> 
<li><b>label_num_to_disease_map.json</b>: Provides a key value pair to tie the label to the appropriate disease/healthy classification tag.</li> 
<li><b>train.csv:</b> tabular file associating training images to disease/healthy classification label</li>
</ul>

## Outcomes and Conclusions of this Study

We preprocessed our training images using ImageDataGenerator and performed a validation split where 20% of our images test the model and 80% of images train our model. We also augment our images by horizontal flips, vertical flips, shifts in ranges, and rotations. 

After our images are preprocessed, we then create a CNN by first applying transfer learning, importing the EfficientNetB4 architecture, and then adding a GlobalAveragePooling2D() and Dense layers to denote the 5 image classifications. Note our batch size is 16, we run 10 epochs, and the target size of each image passed into the CNN is 299x299x3. Our steps per epoch & validation are separated like our training & testing images (20-80 split) and the CNN takes approximately ~50 minutes to run.

We also apply callbacks to make sure our model can stop completely and/or reduce its learning speed when the model does not improve its validation loss. We also tell our model in a call to save the model when the model validation loss improves so we have the best model available for future fine tuning.

After completing 10 epochs, the models finishes with an average validation loss of 38% and an average validation accuracy of 88%. It also identified early stopping on the 10th epoch so no further epochs were required. I used Tensorboard to provide a visual representation on the accuracy and loss per each epoch (you will need to open the notebook in Google Collab to view the Tensorboard as it does not render in GitHub). 

Below are line graphs representing the test & validation accuracy and loss at each epoch:


<p align="center">
<b>Train & Validation Loss</b>
*Note: Train line = Orange; Validation line = Blue
</p>

<p align="center">
<b>Train & Validation Accuracy</b>
*Note: Train line = Orange; Validation line = Blue
</p>

So what's next in this study? we would like to explore the following:

<ol>
<li> <b>Additional Test Time Augmentation (TTA)</b> to further enhance my model. TTA has been known to improve base neural networks by aggregating predictions across transformed versions of test images and it a common practice to expand on base models. I would like to continue to expand on the test time augmentation I performed to include more scenarios. </li>
<li><b>Image Resizing</b>: I would also like to try converting the images into larger ones (e.g.,converting images to 448x448x3) to see if the larger size can help improve scores</li> 
<li><b>Compare Other Transfer Learning</b>: I would like to compare other architectures alongisde EfficientNetB4 to see if they have an improved baseline. And lastly,</li>
<li><b>Oversample classes</b> to adjust for Imbalanced Data: While our accuracy score for our base line CNN is a great start, I'd like to see if I can further improve scores by oversampling other classification groups to help adjust for the imbalanced of image class, CMD. </li>
</ol>



<pre>
Languages    : Python
Tools/IDE    : Google Colab
Libraries    : datetime, numpy, matplotlib, seaborn, random, sklearn, tensorflow, keras, os, cv2, json, PIL
</pre>

<pre>
Assignment Submitted     : December 2025
</pre>

