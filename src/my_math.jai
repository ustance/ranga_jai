#import "Basic";
#import "Math";


//
//	some code from good old game maker days
//  ...
//  don't judge me
//

lengthdir_x :: (distance: float, angle: int) -> float {
	return distance * cos(angle * PI / 180);
}

lengthdir_y :: (distance: float, angle: int) -> float {
	return distance * -sin(angle * PI / 180);
}

lengthdir_x :: (vec: Vector2) -> float {
	x_axis := Vector2.{1.0, 0.0};
	return dot(vec, x_axis) / (length(vec) * length(x_axis));
}

lengthdir_y :: (vec: Vector2) -> float {
	y_axis := Vector2.{0.0, -1.0};
	return dot(vec, y_axis) / (length(vec) * length(y_axis));
}



merge_sort :: (array: [] $T, f: (T, T) -> $R) {
    
    rec :: (a: [] T, cmp: (T, T) -> R, from: int, to: int) {
        middle := (from + to) >> 1;
        if to - from < 12 {
            if to <= from
                return;
            for i: from+1..to-1 {
                j := i;
                while j > from {
                    if cmp(a[j], a[j-1]) < 0
                        swap(a, j - 1, j);
                    else
                        break;
                    j -= 1;
                }
            }
            return;
        }
        
        rec(a, cmp, from, middle);
        rec(a, cmp, middle, to);
        do_merge(a, cmp, from, middle, to, middle - from, to - middle);
    }
    
    do_merge :: (a: []T, cmp: (T, T) -> R, from: int, pivot: int, to: int, len1: int, len2: int) {
        first_cut, second_cut, len11, len22, new_mid: int;
        
        if len1 == 0 || len2 == 0 
            return;
        if len1 + len2 == 2 {
            if cmp(a[pivot], a[from]) < 0
                swap(a, pivot, from);
            return;
        }
        if len1 > len2 {
            len11 = len1 >> 1;
            first_cut = from + len11;
            second_cut = lower(a, cmp, pivot, to, first_cut);
            len22 = second_cut - pivot;
        } else {
            len22 = len2 >> 1;
            second_cut = pivot + len22;
            first_cut = upper(a, cmp, from, pivot, second_cut);
            len11 = first_cut - from;
        }
        rotate(a, cmp, first_cut, pivot, second_cut);
        new_mid = first_cut + len22;
        do_merge(a, cmp, from, first_cut, new_mid, len11, len22);
        do_merge(a, cmp, new_mid, second_cut, to, len1 - len11, len2 - len22);
    }
    
    rotate :: (a: []T, cmp: (T, T) -> R, from: int, mid: int, to: int) {
        n: int;
        if from == mid || mid == to
            return;
        n = gcd(to - from, mid - from);
        while n != 0 {
            val := a[from + n];
            shift := mid - from;
            p1 := from + n;
            p2 := from + n + shift;
            while p2 != from + n {
                a[p1] = a[p2];
                p1 = p2;
                if to - p2 > shift
                    p2 += shift;
                else 
                    p2 = from + (shift - (to - p2));
            }
            a[p1] = val;
            
            n -= 1;
        }
    }
    
    gcd :: (m: int, n: int) -> int {
        while n != 0 {
            t := m % n;
            m = n;
            n = t;
        }
        return m;
    }
    
    upper :: (a: []T, cmp: (T, T) -> R, from: int, to: int, val: int) -> int {
        len := to - from;
        half: int;
        mid: int;
        
        while len > 0 {
            half = len >> 1;
            mid = from + half;
            if cmp(a[val], a[mid]) < 0
                len = half;
            else {
                from = mid + 1;
                len = len - half - 1;
            }
        }
        return from;
    }
    
    lower :: (a: []T, cmp: (T, T) -> R, from: int, to: int, val: int) -> int{
        len := to - from;
        half: int;
        mid: int;
        
        while len > 0 {
            half = len >> 1;
            mid = from + half;
            if cmp(a[mid], a[val]) < 0 {
                from = mid + 1;
                len = len - half - 1;
            } else
                len = half;
        }
        return from;
    }
    
    swap :: (a: []T, i: int, j: int) {
        tmp := a[i];
        a[i] = a[j];
        a[j] = tmp;
    }
    
    rec(array, f, 0, array.count);
}



test_math_functions :: () {
	/* return; */
	/* print("Hello, Math!\n"); */
    
	/* test_vector := make_vector2(1, 1); */
    
	/* print("lengthdir_x(1.0, 45): %\n", lengthdir_x(1.0, 45)); */
	/* print("lengthdir_x(vec2(1, 1)): %\n", lengthdir_x(test_vector)); */
    
	/* print("lengthdir_y(1.0, 45): %\n", lengthdir_y(1.0, 45)); */
	/* print("lengthdir_y(vec2(1, 1)): %\n", lengthdir_y(test_vector)); */
    
}

