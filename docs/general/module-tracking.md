---
title: Module Tracking
---

Pada dasar nya project ini dibuat dengan metode seperti berikut :

```mermaid
graph LR;
    View-->Request;
    Request-->Route;
    Route-->Controller;
    Controller-->Response;
```

Maka untuk tracking modul, dapat dilakukan dengan memperhatikan hal-hal berikut :

## Views 

Untuk views bisa dicek di ```resource\views\...```. Biasanya akan dikirim **Ajax Request** dari sini. Contoh : 



```html title='resources\views\stocker\stocker\stocker-reject\stocker-reject.blade.php'
...

<div>
    <!-- Javascript Action -->
    <button type="button" onclick="exportExcel()" class='btn btn-success'><i class="fa fa-file"></i> Export</button>
</div>

...

<script> 

    ...

    function exportExcel() {
        Swal.fire({
            title: "Exporting",
            html: "Please Wait...",
            timerProgressBar: true,
            didOpen: () => {
                Swal.showLoading();
            },
        });

        // 
        $.ajax({
            url: "{{ route("export-stocker-reject") }}",
            type: "post",
            data: {
                dateFrom : $("#dateFrom").val(),
                dateTo : $("#dateTo").val(),
            },
            xhrFields: { responseType : 'blob' },
            success: function (res) {
                Swal.close();

                iziToast.success({
                    title: 'Success',
                    message: 'Success',
                    position: 'topCenter'
                });

                var blob = new Blob([res]);
                var link = document.createElement('a');
                link.href = window.URL.createObjectURL(blob);
                link.download = "Stocker Reject List "+$("#dateFrom").val()+" - "+$("#dateTo").val()+".xlsx";
                link.click();
            },
            error: function (jqXHR) {
                Swal.close();

                iziToast.error({
                    title: 'Error',
                    message: 'Terjadi Kesalahan',
                    position: 'topCenter'
                });

                console.error(jqXHR);
            }
        });
    }

    ...

</script>

```

## URI

Untuk mendapatkan **nama route**, bisa dengan mengecek endpoint URI dari halaman yang akan dicek.

![URI Image](/assets/images/uri.png)

Atau bisa juga Dengan mengecek **Network/Jaringan** untuk kasus request melalui javascript.

![Network Image](/assets/images/network.png)

Atau jika terbiasa dengan **Laravel Debugbar** bisa dengan mengecek debugbar.

![Laravel Debugbar](/assets/images/debugbar.png)

:::info
Jika ingin melakukan **pengecekan secara detail** yang lebih lengkap dan disertai performa, sebaiknya menggunakan **Laravel Debugbar**.
:::


## Routes

Setelah didapatkan URI-nya maka bisa langsung dicek ke folder project.

![Routes Image](/assets/images/routes.png)

Dalam ```routes\web.php``` terdapat beberapa hal yang perlu diperhatikan:

#### Controller

Biasanya route akan dibungkus dalam satu group berdasarkan satu **Controller**. Sebagai tempat yang menampung function-function yang akan digunakan route dalam group. Untuk track lokasi file Controller yang digunakan bisa dengan mengecek langsung ke ```App\Http\Controllers\...```. Jika menggunakan **VS Code** bisa langsung ```Ctrl+P``` . Atau lebih mudah lagi bisa menggunakan extension.

#### Middleware

Setiap route group biasanya akan menggunakan **Role Middleware**. Untuk membatasi akses user. Contohnya <code>middleware('role:marker,cutting,stocker')</code> , artinya siapa saja yang punya role <code>marker</code>, <code>cutting</code>, atau <code>stocker</code> bisa mengakses rute tersebut. Kamu bisa memasukkan satu atau lebih role ke dalam <code>role:</code>. Filenya bisa dicek di ```App\Http\Middleware\RoleMiddleware.php```.

```php title='App\Http\Middlewate\RoleMiddlewate.php'
<?php

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
        } else if (in_array("management", $roles)) {
            if ($user->roles->whereIn("nama_role", ["management"])->count() > 0) {
                return $next($request);
            }
        } else if (in_array("admin", $roles)) {
            if ($user->roles->whereIn("nama_role", ["admin", "superadmin"])->count() > 0) {
                return $next($request);
            }
        } else {
            if ((!(in_array("accounting", $roles)) || !(in_array("management", $roles))) && $user->roles->whereIn("nama_role", ["admin", "superadmin"])->count() > 0) {
                return $next($request);
            }

            foreach($roles as $role) {
                // Check if user has the role This check will depend on how your roles are set up
                foreach ($user->roles as $userRole) {
                    if ((($role == 'accounting' || $role == 'management') && $userRole->accesses->whereIn("access", [$role])->count() > 0) || (($role != 'accounting' && $role != 'management') && $userRole->accesses->whereIn("access", [$role, "all"])->count() > 0)) {
                        return $next($request);
                    }
                }
            }
        }

        return redirect('home')->with('error', 'You have not access to this module');
    }
}

```

Dan jika ingin melihat daftar middleware lengkapnya bisa dicek di ```App\Http\Kernel.php``` .

```php title='App\Http\Kernel.php'

...

protected $routeMiddleware = [
    'auth' => \App\Http\Middleware\Authenticate::class,
    'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
    'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
    'can' => \Illuminate\Auth\Middleware\Authorize::class,
    'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
    'password.confirm' => \Illuminate\Auth\Middleware\RequirePassword::class,
    'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
    'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
    'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
    'admin' => \App\Http\Middleware\IsAdmin::class,
    'marker' => \App\Http\Middleware\IsMarker::class,
    'spreading' => \App\Http\Middleware\IsSpreading::class,
    'stocker' => \App\Http\Middleware\IsStocker::class,
    'dc' => \App\Http\Middleware\IsDc::class,
    'meja' => \App\Http\Middleware\IsMeja::class,
    'sample' => \App\Http\Middleware\IsSample::class,
    'sewing' => \App\Http\Middleware\IsSewing::class,
    'warehouse' => \App\Http\Middleware\IsWarehouse::class,
    'master-lokasi' => \App\Http\Middleware\IsWarehouse::class,
    'in-material' => \App\Http\Middleware\IsMaterial::class,
    'req-material' => \App\Http\Middleware\IsReqMaterial::class,
    'out-material' => \App\Http\Middleware\IsMaterial::class,
    'mutasi-lokasi' => \App\Http\Middleware\IsMaterial::class,
    'retur-material' => \App\Http\Middleware\IsMaterial::class,
    'retur-inmaterial' => \App\Http\Middleware\IsMaterial::class,
    'qc-pass' => \App\Http\Middleware\IsQcpass::class,
    'manager' => \App\Http\Middleware\IsManager::class,
    'hr' => \App\Http\Middleware\IsHr::class,
    'fg-stock' => \App\Http\Middleware\IsFGStock::class,
    'packing' => \App\Http\Middleware\IsPacking::class,
    'ppic' => \App\Http\Middleware\IsPpic::class,
    'finishgood' => \App\Http\Middleware\IsFinishGood::class,
    'bc' => \App\Http\Middleware\IsBC::class,
    'ga' => \App\Http\Middleware\IsGa::class,
    'so' => \App\Http\Middleware\IsStockOpname::class,
    'marketing' => \App\Http\Middleware\IsMarketing::class,
    'role' => \App\Http\Middleware\RoleMiddleware::class,
];

...

```

### Controller 

Setelah didapatkan **Controller** beserta **Controller Function** dari **Routes**. Maka tinggal dicek Request