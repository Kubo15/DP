clear


%load image and apply otsu thresholding, convert image to binary image(white - 1, black - 0)
Image = imread('csob data/frames/PlanovanePlatby_Rec01/unfiltered/output_0005.png');
level = graythresh(Image);
BW = im2bw(Image,level);


%display binary image
%imshow(BW);

%separate continous objects, each object has his own number
seperatedObjects = bwlabel(BW); 

%reshape array to vector and find the highest object number
reshapedBW = reshape(seperatedObjects,[1,numel(seperatedObjects)]);
maximum = max(reshapedBW);

%find most frequent value other than 0 (0=black), most frequent value has
%the largest object -> most likely to be phone screen
[freq,number]=max(histc(reshapedBW,1:maximum));

se = ones(50,50);
filter = imdilate(seperatedObjects==number,se);
screen = imerode(filter,se);
screen = uint8(screen);

%imshow(screen);
%imshow(B);
%edges = edge(screen, 'sobel');

%imshow(edges);

files = dir('csob data/frames/PlanovanePlatby_Rec01/unfiltered/*.png');
for file = files'
    filename = strcat('csob data/frames/PlanovanePlatby_Rec01/unfiltered/',file.name);
    filteredFileName = strcat('csob data/frames/PlanovanePlatby_Rec01/filtered/',file.name);
    Image = imread(filename);
    Inew = Image.*repmat(screen,[1,1,3]);
    imwrite(Inew,filteredFileName);
    display(strcat({'Processing '}, filteredFileName));
end


