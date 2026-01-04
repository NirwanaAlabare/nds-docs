---
title: "Livewire"
---

Livewire digunakan untuk beberapa komponen yang perlu tampilan dinamis. berikut contoh livewire sederhana :

```php title="app\Http\Livewire\LineDashboardList"
namespace App\Http\Livewire;

use Livewire\Component;
use Livewire\WithPagination;
use Illuminate\Support\Facades\Auth;
use App\Models\SignalBit\UserPassword;
use DB;

class LineDashboardList extends Component
{
    use WithPagination;

    protected $paginationTheme = 'bootstrap';

    public $search = "";
    public $date;
    public $line;

    public function mount()
    {
        $this->date = date('Y-m-d');
    }

    public function render()
    {
        $this->lines = UserPassword::select('username')->
            where('Groupp', 'SEWING')->
            whereRaw('(Locked != 1 OR Locked IS NULL)')->
            whereRaw('REPLACE(username, "_", " ") LIKE "%'.$this->search.'%"')->
            orderBy('username', 'asc')->
            get();

        return view('livewire.line-dashboard-list');
    }
}
```

Untuk tampilannya berada di "<code>resources/views/livewire/...</code>".Contoh : 

```php title="resources/views/livewire/sewing/line-dashboard-list.blade.php"
<div>
    <div class="mb-3">
        <input class="form-control" placeholder="Search Line..." type="text" wire:model="search"/>
    </div>
    <div class="row g-3">
        @foreach ($lines as $line)
            <div class="col-md-3">
                <a class="btn btn-sb w-100" href="http://10.10.5.62:8000/dashboard-wip/line/dashboard1/{{ $line->username }}" target="_blank">
                    {{ strtoupper(str_replace('_', ' ', $line->username)) }}
                </a>
            </div>
        @endforeach
    </div>
</div>
```

Dan untuk memanggilnya di "<code>resources/views/...</code>" adalah sebagai berikut : 

```php title="resources/views/sewing/dashboard-line.blade.php"
@extends('layouts.index')

@section('content')
    <div class="container">
        <div class="card">
            <div class="card-body">
                <h3 class="card-title text-sb text-center fw-bold my-3">Line Dashboard List</h3>
                @livewire('line-dashboard-list')
            </div>
        </div>
    </div>
@endsection
```