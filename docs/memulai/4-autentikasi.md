---
title: "Autentikasi"
---

Untuk pengaturan akses dalam Project ini menggunakan Middleware, terlihat seperti ini :

```php title="app\Http\RoleMiddleware.php"
namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;

class RoleMiddleWare
{
    /**
    * Handle an incoming request.
    *
    * @param  \Illuminate\Http\Request  $request
    * @param  \Closure(\Illuminate\Http\Request): (\Illuminate\Http\Response|\Illuminate\Http\RedirectResponse)  $next
    * @return \Illuminate\Http\Response|\Illuminate\Http\RedirectResponse
    */
    public function handle(Request $request, Closure $next, ...$roles)
    {
        $user = Auth::user();

        if (in_array("superadmin", $roles)) {
            if ($user->roles->whereIn("nama_role", ["superadmin"])->count() > 0) {
                return $next($request);
            }
        } else if (in_array("admin", $roles)) {
            if ($user->roles->whereIn("nama_role", ["admin", "superadmin"])->count() > 0) {
                return $next($request);
            }
        } else {
            if (!(in_array("accounting", $roles)) && $user->roles->whereIn("nama_role", ["admin", "superadmin"])->count() > 0) {
                return $next($request);
            }

            foreach($roles as $role) {
                // Check if user has the role This check will depend on how your roles are set up
                foreach ($user->roles as $userRole) {
                    if (($role == 'accounting' && $userRole->accesses->whereIn("access", [$role])->count() > 0) || ($role != 'accounting' && $userRole->accesses->whereIn("access", [$role, "all"])->count() > 0)) {
                        return $next($request);
                    }
                }
            }
        }

        return redirect('home')->with('error', 'You have not access to this module');
    }
}
```

Dan cara penggunaannya seperti ini:

```php title="routes/web.php"
...

Route::controller(PartController::class)->prefix("part")->middleware('role:marker,cutting,stocker')->group(function () {
    Route::get('/', 'index')->name('part');
    Route::get('/create', 'create')->name('create-part');
    Route::post('/store', 'store')->name('store-part');
    Route::get('/edit', 'edit')->name('edit-part');
    Route::put('/update/{id?}', 'update')->name('update-part');
    Route::delete('/destroy/{id?}', 'destroy')->name('destroy-part');
});

...
```

<code>middleware('role:marker,cutting,stocker')</code> adalah dimana middleware itu dipanggil. Artinya siapa saja yang punya role <code>marker</code>, <code>cutting</code>, atau <code>stocker</code> bisa mengakses rute tersebut. Kamu bisa memasukkan satu atau lebih role ke dalam <code>role:</code>.

Untuk **blade if**, yang biasanya digunakan di front-end, kode nya seperti berikut :

```php title="app/Providers/AppServiceProvider.php
Blade::if('role', function (...$roles) {
$user = auth()->user();

if (in_array("superadmin", $roles)) {
    if ($user->roles->whereIn("nama_role", ["superadmin"])->count() > 0) {
        return true;
    }
} else if (in_array("admin", $roles)) {
    if ($user->roles->whereIn("nama_role", ["admin", "superadmin"])->count() > 0) {
        return true;
    }
} else {
    if (!(in_array("accounting", $roles)) && $user->roles->whereIn("nama_role", ["admin", "superadmin"])->count() > 0) {
        return true;
    }

    foreach($roles as $role) {
        // Check if user has the role This check will depend on how your roles are set up
        foreach ($user->roles as $userRole) {
            if (($role == 'accounting' && $userRole->accesses->whereIn("access", [$role])->count() > 0) || ($role != 'accounting' && $userRole->accesses->whereIn("access", [$role, "all"])->count() > 0)) {
                return true;
            }
        }
    }
}
});
```

Dan ini contoh penggunaannya : 

```php title="resources/views/..."
@role('stocker')
    <div class="col-lg-2 col-md-3 col-sm-6">
        <a class="home-item" href="{{ route('dashboard-stocker') }}">
            <div class="card h-100">
                <div class="card-body">
                    <div class="d-flex h-100 flex-column justify-content-between">
                        <img alt="stocker image" class="img-fluid p-3" src="{{ asset('dist/img/stocker.png') }}"/>
                        <p class="text-center fw-bold text-uppercase text-dark">Stocker</p>
                    </div>
                </div>
            </div>
        </a>
    </div>
@endrole
```

<code>@role('namaAkses')</code> untuk mendefinisikan elemen yang hanya bisa dilihat oleh role tertentu. 