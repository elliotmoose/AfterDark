enum DisplayBarListMode
{
    case alphabetical
    case avgRating
    case priceRating
    case foodRating
    case ambienceRating
    case serviceRating
    
}
enum Arrangement
{
    case nearby
    case priceLow
    case avgRating
    case bestDiscount
}
struct Rating {
    var avg: Float
    var price: Float
    var ambience: Float
    var food: Float
    var service: Float
    
    init()
    {
        avg = 0
        price = 0
        ambience = 0
        food = 0
        service = 0
    }
    
    mutating func InjectValues(_ avgx: Float, pricex: Float, ambiencex: Float, foodx: Float, servicex: Float)
    {
        avg = avgx
        price = pricex
        ambience = ambiencex
        food = foodx
        service = servicex
    }
}

