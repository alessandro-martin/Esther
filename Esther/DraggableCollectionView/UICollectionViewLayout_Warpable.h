@import Foundation;

@class LSCollectionViewLayoutHelper;

@protocol UICollectionViewLayout_Warpable <NSObject>
@required

@property (readonly, nonatomic) LSCollectionViewLayoutHelper *layoutHelper;
@end