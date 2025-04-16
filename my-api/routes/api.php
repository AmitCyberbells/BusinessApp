use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/business-types', function () {
    return response()->json([
        "Food and Beverage",
        "abc",
        "Retail and Shopping",
        "Health and Wellness",
        "Entertainment and Leisure",
        "Hospitality and Travel",
        "Personal Services",
        "Education and Learning",
        "Events and Experience",
        "Automotive and Transportation"
    ]);
});
