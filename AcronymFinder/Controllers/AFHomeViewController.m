//
//  AFHomeViewController.m
//  AcronymFinder
//
//  Created by SaratS on 10/04/17.
//  Copyright © 2017 SaratS. All rights reserved.
//

#import "AFHomeViewController.h"
#import "AFAcronym.h"
#import "AFMeaning.h"
#import "AFServiceManager.h"
#import "AFConstants.h"
#import "AFMeaningTableViewCell.h"
#import "MBProgressHUD.h"

#define TABLE_VIEW_ESTIMATED_ROW_HEIGHT 40.0
#define MEANINGS_TABLE_HEADER_HEIGHT 50.0

@interface AFHomeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *acronymMeaningsTableView;
@property (strong, nonatomic) AFAcronym *acronym;
@property (strong, nonatomic) NSCharacterSet *disallowedCharacters;

@end

@implementation AFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetContent];
    self.searchTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    // Only alpha-numeric characters are allowed to enter in textfield. below set has the disallowed characters
    self.disallowedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    
    self.acronymMeaningsTableView.estimatedRowHeight = TABLE_VIEW_ESTIMATED_ROW_HEIGHT;
    self.acronymMeaningsTableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // reset All content on screen when user starts entering any text
    [self resetContent];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // When there is no text in textfield, Dismiss Keyboard on return. Else, go for fetching
    [textField resignFirstResponder];
    if(![textField.text isEqualToString:@""]){
        
        [self fetchMeaningsForAcronym:textField.text];
    }
    return YES;
}

/*
 * Validations for TextField entries
 * Checking for below 3 conditions
 * 1. If entered text is less than MAX_ACRONYM_LENGTH
 * (MAX_ACRONYM_LENGTH is set to 20 for this sample. Value is configurable in Constants.)
 * 2. accept return key
 * 3. accept only alphabets and numeric characters.
 */

-(BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    return (newLength <= MAX_ACRONYM_LENGTH || ([string rangeOfString: @"\n"].location != NSNotFound)) && ([string rangeOfCharacterFromSet:self.disallowedCharacters].location == NSNotFound);
}


#pragma mark- UITableView Datasource methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.acronym.meanings.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuseIdentifier = @"CellIdentifier";
    
    AFMeaningTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    AFMeaning *meaning = [self.acronym.meanings objectAtIndex:indexPath.row];
    cell.meaningLabel.text = meaning.meaning;
    
    return cell;
}

#pragma mark- UITableView Delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return MEANINGS_TABLE_HEADER_HEIGHT;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:NSLocalizedString(@"HeaderText", @""),self.searchTextField.text];
}

#pragma mark - Web service
-(void) fetchMeaningsForAcronym: (NSString *) acronym {

    // show loading indicator when  service call is made
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.detailsLabel.text = NSLocalizedString(@"FetchingMeaningsProgressMessage", @"");
    
    [[AFServiceManager sharedManager] getMeaningsForAcronym:acronym success:^(AFAcronym *acronym) {
        
        dispatch_async (dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.acronym = acronym;
            if (self.acronym && self.acronym.meanings.count > 0) {
                [self.acronymMeaningsTableView setHidden:NO];
                [self.acronymMeaningsTableView setContentOffset:CGPointZero animated:NO];
                [self.acronymMeaningsTableView reloadData];
            }
            else{
                // show no results alert
                [self showAlertWithTitle:NSLocalizedString(@"NoResultsTitle", @"") message:[NSString stringWithFormat:NSLocalizedString(@"NoResultsMessage", @""),self.searchTextField.text]];
            }
        });
    } failure:^(NSError *error) {
        
        dispatch_async (dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            // show error alert with error description
            [self showAlertWithTitle:nil message:error.localizedDescription];
        });
    }];
}

#pragma mark - Helper methods
/*
 * Resets content and Hides table view
 */
-(void) resetContent{
    [self.acronymMeaningsTableView setHidden:YES];
    self.acronym = nil;
}

#pragma mark - Alerts
-(void)showAlertWithTitle:(NSString *) title message:(NSString *) message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"AlertTitleOK", @"") style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
