var display = false
var fourwheels = true
var rearDrive = true

$(function(){
	window.onload = (e) => {

		window.addEventListener('message', (event) => {

			var a = event.data;
			display = event.data.display;
			fourwheels = event.data.fourwheels;
			rearDrive = event.data.rearDrive;
			if (a !== undefined && a.type === "ui") {

				if (display === true) {
                    $("#container").css("display", "block");

				} else{
                    $("#container").css("display", "none");
				}
				if (fourwheels === true) {
					$('#wheels').attr('src', 'img/4wheels.png');
				} else
				{
					if (rearDrive == false )
					{
						$('#wheels').attr('src', 'img/2wheels.png');
					}
					else
					{
						$('#wheels').attr('src', 'img/2wheelsRWD.png');
					}

				}
			}
		});
	};
});


