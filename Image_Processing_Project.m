%% Cartoon and Anime Style Converter in MATLAB

% Ask user to upload an image
[filename, pathname] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp','Image Files (*.jpg, *.png, *.bmp)'}, ...
    'Select an Image');
if isequal(filename, 0)
    disp('User canceled the file selection.');
    return;
end

% Read the selected image
imagePath = fullfile(pathname, filename);
image = imread(imagePath);

% Resize the image for faster processing (optional)
scaleFactor = 0.5;
resizedImage = imresize(image, scaleFactor);

%% Cartoon-like Image (Bold Edges)
% Convert to grayscale
grayImage = rgb2gray(resizedImage);

% Detect edges using Canny
edges = edge(grayImage, 'Canny');

% Thicken the edges
se = strel('disk', 2);
thickEdges = imdilate(edges, se);

% Overlay black edges on the image
cartoonImage = resizedImage;
cartoonImage(repmat(thickEdges, [1, 1, 3])) = 0;

%% Anime-style Image (Color Quantization + Laplacian)
% Quantize colors by reducing intensity levels
numColors = 8;
quantizedImage = uint8(floor(double(resizedImage) / (256 / numColors)) * (256 / numColors));

% Apply Laplacian filter to emphasize edges
laplacianFilter = fspecial('laplacian', 0.2);
edgeImage = imfilter(rgb2gray(quantizedImage), laplacianFilter);

% Add line-art effect to each RGB channel
animeImage = quantizedImage;
for channel = 1:3
    tempChannel = animeImage(:,:,channel);
    tempChannel = imsubtract(tempChannel, uint8(edgeImage));
    animeImage(:,:,channel) = tempChannel;
end

%% Display Results
figure('Name','Cartoon and Anime Style Conversion');
subplot(1, 3, 1);
imshow(resizedImage);
title('Original Image');

subplot(1, 3, 2);
imshow(cartoonImage);
title('Cartoon-like Image');

subplot(1, 3, 3);
imshow(animeImage);
title('Anime-style Image');
