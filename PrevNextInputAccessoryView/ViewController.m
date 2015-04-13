//
//  ViewController.m
//  PrevNextInputAccessoryView
//
//  Created by Christopher Rung on 4/12/15.
//  Copyright (c) 2015 Christopher Rung. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;

@property (strong, nonatomic) UITextField *activeTextField;
@property (strong, nonatomic) NSArray *inputAccessoryViews;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupInputAccessoryViews];
    
    // monitor which field is currently selected, and set each of the input accessory views.
    for(UITextField *field in _textFields) {
        [field addTarget:self action:@selector(fieldSelected:) forControlEvents:UIControlEventEditingDidBegin];
        [field setInputAccessoryView:[_inputAccessoryViews objectAtIndex:field.tag]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//
// Create the 4 accessory views for each of the the UITextFields, each containing
// a previous button, a next button, and a done button.
//
- (void)setupInputAccessoryViews {
    _inputAccessoryViews = [[NSArray alloc] initWithObjects:[[UIToolbar alloc] init], [[UIToolbar alloc] init], [[UIToolbar alloc] init], [[UIToolbar alloc] init], nil];
    
    for(UIToolbar *accessoryView in _inputAccessoryViews) {
        UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:101 target:nil action:@selector(goToPrevField)]; // 101 is the < character
        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:102 target:nil action:@selector(goToNextField)]; // 102 is the > character
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:@selector(dismissKeyboard)];
        UIBarButtonItem *flexSpace  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *fake       = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        [accessoryView sizeToFit];
        [accessoryView setItems:[NSArray arrayWithObjects: prevButton, fake, nextButton, fake, flexSpace, fake, doneButton, nil] animated:YES];
    }
    
    // disable the previous button in the first accessory view
    ((UIBarButtonItem*)[((UIToolbar*)[_inputAccessoryViews objectAtIndex:0]).items objectAtIndex:0]).enabled = NO;
    // disable the next button in the last accessory view
    ((UIBarButtonItem*)[((UIToolbar*)[_inputAccessoryViews objectAtIndex:3]).items objectAtIndex:2]).enabled = NO;
}

- (void)fieldSelected:(UITextField*)selectedField {
    _activeTextField = selectedField;
}

//
// Focus on the previous UITextField
//
- (void)goToPrevField {
    [[_textFields objectAtIndex:(_activeTextField.tag - 1)] becomeFirstResponder];
}

//
// Focus on the next UITextField
//
- (void)goToNextField {
    [[_textFields objectAtIndex:(_activeTextField.tag + 1)] becomeFirstResponder];
}

//
// Dismiss the keyboard when done is tapped.
//
- (void)dismissKeyboard {
    [[_textFields objectAtIndex:_activeTextField.tag] resignFirstResponder];
}

//
// Controls behavior of touching the Next or Done button in the keyboard.
//
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // if currently focused on first three textboxes, go to the next text box
    if (textField.tag < 3) {
        [[_textFields objectAtIndex:(textField.tag + 1)] becomeFirstResponder];
        // if currently focused on last textbox, dismiss the keyboard.
    } else if (textField.tag == 3) {
        [[_textFields objectAtIndex:3] resignFirstResponder];
    }
    
    return YES;
}

@end