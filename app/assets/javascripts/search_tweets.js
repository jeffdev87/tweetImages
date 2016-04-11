// The js code needs to be put inside this block.
$(document).on('ready page:load', function () {
	
	var 
	// Maximum number of visible images in the container
	maxDisplayedImages = 3,
	
	// Image container with the tweet's images
	imgContainer = '.imageSliderDivContainerClass img',

	// Image container with the divs of similar images
	imageContainerDivs = '.imageSliderDivContainerClass div',
	
	// Image container with the similar images
	similarImageContainer = '.imageSimilarSliderDivContainerClass img',

	// Image container with the similar images divs
	similarImageContainerDivs = '.imageSimilarSliderDivContainerClass div',
    
    // Number of images returned from the search for tweets
    imageDivNum = $(imgContainer).length,

    // Number of images returned from the sarch for similar
    similarImageDivNum = $(similarImageContainer).length;

	// Add event to disable/enable the image navigation buttons
	window.addEventListener("load", 
							function() {
								updateNavButtonStatus ('nextBtId', 'prevBtId', imageDivNum);
								updateNavButtonStatus ('nextSimBtId', 'prevSimBtId', similarImageDivNum);

								updateSearchButtonStatus('searchButton', 'searchText');
								//updateSearchButtonStatus('searchSimilarButton', 'imageUrl');
							}, false); 

	// Update the similar search form given the selected image
	function updateSearchSimilarForm(imageElement) {
		
		if (imageElement instanceof HTMLImageElement) {
			// imageId is the id of the text field
			textFieldImageId = 'imageId';
			textFiledImageUrl = 'imageUrl';

			// Set the image properties to the form fields
			if (elementIdExists(textFieldImageId) &&
				elementIdExists(textFiledImageUrl)) {

				document.getElementById(textFieldImageId).value = imageElement.id;
				document.getElementById(textFiledImageUrl).value = imageElement.src;
			}			
		}
	}

	// Check whether a given textbox is empty
	function isTextBoxEmpty (textBoxId) {
		var textBoxElement = document.getElementById(textBoxId);

		if (textBoxElement == null || 
			textBoxElement.value == "")
			return true;
		else
			return false;
	}

	// Update the navigation buttons given the buttons id and the number of 
	// images in the respective image container
	function updateNavButtonStatus (next, prev, imgDivNum) {
		if (elementIdExists(next) &&
			elementIdExists(prev)) {
			if (imgDivNum) {
				changeNavButtonDisabledStatus(next, prev, false);
			}
			else {
				changeNavButtonDisabledStatus(next, prev, true);
			}
		}		
	}

	// Update the search button given the button id and the 
	// status of its respective search textbox
	function updateSearchButtonStatus (searchBtId, searchTextId) {
		if (elementIdExists(searchBtId)) {
			if (isTextBoxEmpty(searchTextId)) {
				changeSearchButtonDisabledStatus(searchBtId, true);
			}
			else {
				changeSearchButtonDisabledStatus(searchBtId, false);
			}
		}		
	}	

	// Change search button to the provided status given the button id
	function changeSearchButtonDisabledStatus (searchBtId, status) {
		if (status != false && 
			status != true)
			status = true;

		document.getElementById(searchBtId).disabled = status;
	}

	// Change navigation buttons to the provided status given the buttons id
	function changeNavButtonDisabledStatus (nextId, prevId, status) {
		if (status != false && 
			status != true)
			status = true;

		if (elementIdExists(nextId))
			document.getElementById(nextId).disabled = status; 
		
		if (elementIdExists(prevId))
			document.getElementById(prevId).disabled = status; 
	}

	// Check if a given element exists
	function elementIdExists (elementId) {
		return (document.getElementById(elementId) != null);
	}

	// Set the focus to a given textbox element by id
	function setFocusTextBox (elementId) {
		searchTextElement = document.getElementById(elementId);

		if (searchTextElement != null) {
			searchTextElement.focus();
			searchTextElement.setSelectionRange(0, searchTextElement.value.length);
		}
	}

	// Show only the divs specified by the array 
	function showDisplayableDivs(imageContainerDiv) {
		
		imageContainerDivs = $(imageContainerDiv);
		
		// Hide all items first
		imageContainerDivs.hide();

		var i = 0;

		// Show specified divs
		for (i = 0; i < maxDisplayedImages; i++) {
			if ($(imgContainer) != null) {
				var item = imageContainerDivs.eq(i);
				item.css('display','inline-block');	
			}
		}
	}

	// Round images from a given container, to a given direction
	function roundImages(direction, imgContainer, imgDivNumVar) {
		
		var i;

		// To the right
		if (direction) {
			i = 0;
			var last = $(imgContainer).eq(i).attr('src');

			for (i = 1; i < imgDivNumVar - 1; i++) {
				var currItem = $(imgContainer).eq(i);
				    aux = currItem.attr('src');
				
				currItem.attr('src', last);
				last = aux;
			}
			// Swap the last one with the first one
			var lastItem = $(imgContainer).eq(i),
				firstItem = $(imgContainer).eq(0),
				aux = lastItem.attr('src');

			lastItem.attr('src', last);
			firstItem.attr('src', aux);
		}
		// To the left
		else {
			i = 0;
			var init = $(imgContainer).eq(i).attr('src');

			for (i = 0; i < imgDivNumVar - 1; i++) {
				var currItem = $(imgContainer).eq(i),
				    ahead = $(imgContainer).eq(i + 1).attr('src');
				
				currItem.attr('src', ahead);
			}
			var lastItem = $(imgContainer).eq(i);
			lastItem.attr('src', init);
		}
	}

	// Navigation buttons behaviour of the imageSliderDivContainerClass
	// container
	$('.next').click(
				function() {
					var left = 1;
					roundImages(left, imgContainer, imageDivNum);
					setFocusTextBox('searchText');
				});

	$('.prev').click(
				function() {
					var right = 0;
					roundImages(right, imgContainer, imageDivNum);
					setFocusTextBox('searchText');
				});

	// Navigation buttons behaviour of the imageSimilarSliderDivContainerClass 
	// container
	$('.next_sim').click(
				function() {
					var left = 1;
					roundImages(left, similarImageContainer, similarImageDivNum);
				});

	$('.prev_sim').click(
				function() {
					var right = 0;
					roundImages(right, similarImageContainer, similarImageDivNum);
				});

	// Search button behaviour
	$('.searchButtonClass').click(
							function() {
								changeNavButtonDisabledStatus(true);
							});

	// Add keyup event to control whether disable the button or not
	$('.searchTextClass').keyup(
							function() {
								updateSearchButtonStatus('searchButton', 'searchText');
							});

	// Since we don't control this input text box, we add the change event.
	// Change event is not working, it is fired only when the text field loses its focus.
	$('.imageInputClass').change(
							function() {
								updateSearchButtonStatus('searchSimilarButton', 'imageUrl');
							});


	$('.imgItemClass').click(
							function() {
								var imgElement = this;
								updateSearchSimilarForm(imgElement);
							});

	// Run the following functions
	showDisplayableDivs(imageContainerDivs);
	showDisplayableDivs(similarImageContainerDivs);

	setFocusTextBox('searchText');
});